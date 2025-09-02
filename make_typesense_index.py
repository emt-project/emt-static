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


try:
    client.collections["emt"].delete()
except ObjectNotFound:
    pass

current_schema = {
    "name": "emt",
    "fields": [
        {"name": "id", "type": "string"},
        {"name": "rec_id", "type": "string"},
        {"name": "title", "type": "string"},
        {"name": "full_text", "type": "string"},
        {"name": "regest", "type": "string"},
        {"name": "date", "type": "int32"},
        {
            "name": "year",
            "type": "int32",
            "optional": True,
            "facet": True,
        },
        {"name": "persons", "type": "string[]", "facet": True, "optional": True},
        {"name": "sender", "type": "string[]", "facet": True, "optional": True},
        {"name": "receiver", "type": "string[]", "facet": True, "optional": True},
        {"name": "places", "type": "string[]", "facet": True, "optional": True},
        {"name": "orgs", "type": "string[]", "facet": True, "optional": True},
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
    try:
        date_str = doc.any_xpath("//tei:origDate/@when-iso")[0]
    except IndexError:
        date_str = "1000"

    try:
        record["year"] = int(date_str[:4])
        cfts_record["year"] = int(date_str[:4])
    except ValueError:
        pass
    record["persons"] = [
        " ".join(" ".join(x.xpath(".//text()")).split())
        for x in doc.any_xpath(".//tei:correspAction//tei:persName[1]")
    ]
    record["sender"] = []
    try:
        place = doc.any_xpath('.//tei:correspAction[@type="sent"]/tei:persName/text()')[
            0
        ]
    except:
        place = None
    record["sender"].append(place)
    record["receiver"] = []
    try:
        receiver = doc.any_xpath(
            './/tei:correspAction[@type="received"]/tei:persName/text()'
        )[0]
    except:
        receiver = None
    if receiver:
        record["receiver"].append(receiver)

    cfts_record["persons"] = record["persons"]
    record["places"] = []
    try:
        place = doc.any_xpath(
            './/tei:correspAction[@type="sent"]/tei:placeName/text()'
        )[0]
    except:
        place = None
    if place:
        record["places"].append(place)
        cfts_record["places"] = record["places"]
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
        if date_string:
            pass
        else:
            date_string = "1800-01-01"
    except:
        date_string = "1800-01-01"
    date_object = datetime.strptime(date_string, "%Y-%m-%d")
    time_tuple = date_object.timetuple()
    unix_timestamp = calendar.timegm(time_tuple)
    record["date"] = unix_timestamp * -1  # dirty trick to change sort order
    records.append(record)
    cfts_records.append(cfts_record)

make_index = client.collections["emt"].documents.import_(records)
print(make_index)
print("done with indexing emt")

# make_index = CFTS_COLLECTION.documents.import_(cfts_records, {"action": "upsert"})
print(make_index)
print("done with cfts-index emt")
