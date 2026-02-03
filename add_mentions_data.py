import glob
import requests
from acdh_tei_pyutils.tei import TeiReader
import lxml.etree as ET

print("adding mentioned letters")

files = sorted(glob.glob("./data/editions/*.xml", recursive=True))
mentions_data = requests.get(
    "https://raw.githubusercontent.com/emt-project/emt-entities/refs/heads/main/json_dumps/mentioned_letters.json"
).json()

for x in files:
    doc = TeiReader(x)
    if doc.any_xpath("//tei:body//tei:ref[not(ancestor::tei:note)]"):
        #add a listBibl to the back
        list_bibl = doc.any_xpath("//tei:back/tei:listBibl")
        if len(list_bibl) == 0:
            list_bibl = ET.SubElement(doc.any_xpath(".//tei:back")[0],
                            "listBibl", type="mentionedLetters"
                        )
        else:
            list_bibl = list_bibl[0]
            print(f"listBibl already exists in {x}")
        for y in doc.any_xpath("//tei:body//tei:ref[not(ancestor::tei:note)]"):
            unique_letters = set()
            targets = y.get("target").split()
            # prefix for mentions in the Baserow table
            br_prefix = "#emt_letter_id__"
            for target in targets:
                if target.startswith(br_prefix):
                    mention_id = target.removeprefix(br_prefix)
                    if mention_id in mentions_data and mention_id not in unique_letters:
                        mention_info = mentions_data[mention_id]
                        bibl = ET.SubElement(list_bibl,
                                            "bibl",
                                            {"{http://www.w3.org/XML/1998/namespace}id": target[1:]})
                        date_attribs = {}
                        if mention_info.get("when"):
                            date_attribs["when-iso"] = mention_info["when"]
                        else:
                            if mention_info.get("not_before"):
                                date_attribs["notBefore"] = mention_info["not_before"]
                            if mention_info.get("not_after"):
                                date_attribs["notAfter"] = mention_info["not_after"]
                        ET.SubElement(bibl, "date", date_attribs)
                        sender = mention_info["sender"][0]
                        recipient = mention_info["recipient"][0]
                        ET.SubElement(bibl, "persName", ref=f"#emt_person_id__{sender['id']}",role="sender").text = sender["value"]
                        ET.SubElement(bibl, "persName", ref=f"#emt_person_id__{recipient['id']}",role="recipient").text = recipient["value"]
                        unique_letters.add(mention_id)
    doc.tree_to_file(x)