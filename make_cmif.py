import glob
import os
import jinja2
import lxml.etree as ET
from datetime import date
from acdh_cidoc_pyutils import extract_begin_end
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash, make_entity_label
from acdh_xml_pyutils.xml import NSMAP
from tqdm import tqdm

templateLoader = jinja2.FileSystemLoader(searchpath="./templates")
templateEnv = jinja2.Environment(loader=templateLoader)
template = templateEnv.get_template("cmif.j2")
DOMAIN = "https://kaiserin-eleonora.oeaw.ac.at/"
current_date = date.today().strftime("%Y-%m-%d")

files = sorted(glob.glob("./data/editions/*.xml"))

items = []
excluded = set()
for x in tqdm(files, total=len(files)):
    doc_id = os.path.split(x)[-1]
    item = {"doc_id": doc_id.replace(".xml", ".html")}
    doc = TeiReader(x)
    # sender
    try:
        item_ref = doc.any_xpath(
            ".//tei:correspAction[@type='sent']/tei:persName/@ref"
        )[0]
    except IndexError:
        excluded.add(x)
        continue
    try:
        item_node = doc.any_xpath(
            f".//tei:person[@xml:id='{check_for_hash(item_ref)}']"
        )[0]
    except IndexError:
        excluded.add(x)
        continue
    item_label = make_entity_label(item_node.xpath("./*[1]")[0])[0]
    item_gnd = item_node.xpath("./tei:idno[@type='GND']/text()", namespaces=NSMAP)[0]
    item["sender_label"] = item_label
    item["sender_gnd"] = item_gnd

    # receiver
    try:
        item_ref = doc.any_xpath(
            ".//tei:correspAction[@type='received']/tei:persName/@ref"
        )[0]
    except IndexError:
        excluded.add(x)
        continue
    try:
        item_node = doc.any_xpath(
            f".//tei:person[@xml:id='{check_for_hash(item_ref)}']"
        )[0]
    except IndexError:
        excluded.add(x)
        continue
    item_label = make_entity_label(item_node.xpath("./*[1]")[0])[0]
    try:
        item_gnd = item_node.xpath("./tei:idno[@type='GND']/text()", namespaces=NSMAP)[0]
    except IndexError:
        item_gnd = False
    item["receiver_label"] = item_label
    item["receiver_gnd"] = item_gnd

    # date
    date = doc.any_xpath(".//tei:correspAction[@type='sent']/tei:date")[0]
    start, end = extract_begin_end(date)
    new_date = ET.Element("date")
    if start and start != end:
        new_date.attrib["notBefore"] = start
        new_date.attrib["notAfter"] = end
        new_date.text = date.text
    elif start == end and start:
        new_date.attrib["when"] = start
        new_date.text = start
    date_str = ET.tostring(
        new_date, with_tail=False, inclusive_ns_prefixes=NSMAP
    ).decode("utf-8")
    if len(date_str) < 8:
        item["date"] = None
    else:
        item["date"] = date_str

    # place
    try:
        item_ref = doc.any_xpath(
            ".//tei:correspAction[@type='sent']/tei:placeName/@ref"
        )[0]
    except IndexError:
        excluded.add(x)
        item["place_label"] = "o.O"
        item["place_geonames"] = False
    try:
        item_node = doc.any_xpath(
            f".//tei:place[@xml:id='{check_for_hash(item_ref)}']"
        )[0]
        item_geonames = True
    except IndexError:
        item_geonames = None
    if item_geonames:
        item_label = make_entity_label(item_node.xpath("./*[1]")[0])[0]
        item_geonames = item_node.xpath(
            "./tei:idno[@type='GEONAMES']/text()", namespaces=NSMAP
        )[0]
        item["place_label"] = item_label
        item["place_geonames"] = item_geonames
    else:
        try:
            item["place_label"] = doc.any_xpath(
                ".//tei:correspAction[@type='sent']/tei:placeName/text()"
            )[0]
        except IndexError:
            print(x)
            item["place_label"] = False
    if item["place_label"] == "o.O.":
        item["place_label"] = False
        item["place_geonames"] = False
    items.append(item)

with open("./data/indices/cmif.xml", "w") as f:
    f.write(template.render({"data": items, "domain": DOMAIN, "date": current_date}))

for x in excluded:
    print(x)
print(f"excluded {len(x)} of {len(files)} letters")
print(f"collected {len(items)} items for CMIF file")
