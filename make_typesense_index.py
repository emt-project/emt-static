import calendar
import glob
import os
from datetime import datetime

from typesense.api_call import ObjectNotFound
from acdh_cfts_pyutils import TYPESENSE_CLIENT as client
from acdh_cfts_pyutils import CFTS_COLLECTION
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from acdh_cidoc_pyutils import extract_begin_end
from tqdm import tqdm


files = glob.glob("./data/editions/*.xml")
tag_blacklist = ["{http://www.tei-c.org/ns/1.0}abbr"]

def get_corresp_info(doc, action_type, tag):
    try:
        node = doc.any_xpath(f'.//tei:correspAction[@type="{action_type}"]/tei:{tag}')[0]
        name = " ".join("".join(node.xpath('.//text()')).split())
        ref = node.get("ref", "").lstrip("#")
        return {"name": name, "id": ref}
    except IndexError:
        return {}

def get_list_items(doc, list_tag, item_tag, name_tag):
    items = []
    for x in doc.any_xpath(f".//tei:{list_tag}/tei:{item_tag}"):
        name = " ".join(" ".join(x.xpath(f".//tei:{name_tag}[1]//text()", namespaces= {"tei": "http://www.tei-c.org/ns/1.0"})).split())
        items.append({"name": name, "id": x.get("xml:id")})
    return items


try:
    client.collections["emt"].delete()
except ObjectNotFound:
    pass
current_schema = {
    "name": "emt",
    "enable_nested_fields": True,
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {"name": "regest", "type": "string"},
        {"name": "date", "type": "int64","sort": True,},
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
        },
        {"name": "sender", "type": "object", "facet": True, "optional": True},
        {"name": "receiver", "type": "object", "facet": True, "optional": True},
        {"name": "sent_from", "type": "object", "facet": True, "optional": True},
        {
            "name": "mentioned_persons",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {
            "name": "mentioned_places",
            "type": "object[]",
            "facet": True,
            "optional": True,
        },
        {"name": "orgs", "type": "object[]", "facet": True, "optional": True},
        {"name": "keywords", "type": "string[]", "facet": True, "optional": True},
    ],
    "default_sorting_field": "date",
}

client.collections.create(current_schema)

records = []
cfts_records = []
for x in tqdm(files, total=len(files)):
    cfts_record = {
        "project": "emt",
    }
    record = {}

    doc = TeiReader(x)
    try:
        body = doc.any_xpath(".//tei:body")[0]
    except IndexError:
        continue
    record["id"] = os.path.split(x)[-1].replace(".xml", "")
    record["keywords"] = doc.any_xpath(
        './/tei:abstract/tei:ab[@type="abstract-terms"]/tei:term/text()'
    )
    cfts_record["id"] = record["id"]
    cfts_record["resolver"] = f"https://emt.acdh-dev.oeaw.ac.at/{record['id']}.html"
    record["rec_id"] = os.path.split(x)[-1]
    cfts_record["rec_id"] = record["rec_id"]
    record["title"] = " ".join(
        " ".join(
            doc.any_xpath('.//tei:titleStmt/tei:title[@type="main"]/text()')
        ).split()
    )
    cfts_record["title"] = record["title"]    
    record["full_text"] = extract_fulltext(body, tag_blacklist=tag_blacklist)
    try:
        regest = doc.any_xpath('.//tei:abstract[@n="regest"]')[0]
    except IndexError:
        regest = None
    if regest is not None:
        record["regest"] = extract_fulltext(regest, tag_blacklist=tag_blacklist)
    else:
        record["regest"] = None
    cfts_record["full_text"] = record["full_text"]

    try:
        date_node = doc.any_xpath("//tei:correspAction/tei:date")[0]
        date_string = extract_begin_end(date_node)[0]
        
        if date_string and date_string[:4].isdigit():
            # Add year as facet only for valid years
            year_val = int(date_string[:4])
            record["year"] = year_val
            cfts_record["year"] = year_val

        else:
            date_string= "1800-01-01"  # Fallback for invalid dates
    except Exception:
        date_string= "1800-01-01" 
    date_object = datetime.strptime(date_string, "%Y-%m-%d")
    time_tuple = date_object.timetuple()
    unix_timestamp = calendar.timegm(time_tuple)
    record["date"] = -unix_timestamp # Negate for reverse sorting

    # entities with a single object
    record["sender"] = get_corresp_info(doc, "sent", "persName")
    record["receiver"] = get_corresp_info(doc, "received", "persName")
    record["sent_from"] = get_corresp_info(doc, "sent", "placeName")
    cfts_record["receiver"] = record["receiver"]
    cfts_record["sender"] = record["sender"]
    cfts_record["sent_from"] = record["sent_from"]
    
    # entities with object lists
    record["mentioned_persons"] = get_list_items(doc, "listPerson", "person", "persName")
    record["mentioned_places"] = get_list_items(doc, "listPlace", "place", "placeName")
    record["orgs"] = get_list_items(doc, "listOrg", "org", "orgName")
    cfts_record["mentioned_persons"] = record["mentioned_persons"]
    cfts_record["mentioned_places"] = record["mentioned_places"]
    cfts_record["orgs"] = record["orgs"]
    
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections["emt"].documents.import_(records)
print(make_index)
print("done with indexing emt")

# make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print("done with cfts-index emt")
