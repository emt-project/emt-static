import glob
import requests
from acdh_tei_pyutils.tei import TeiReader
import lxml.etree as ET
import os

print("adding mentioned letters")
def build_bibl_entry(list_bibl, bibl_id, date_attribs, sender, recipient):
    # build the bibl entry for the mentioned letter
    bibl = ET.SubElement(list_bibl,"bibl",{"{http://www.w3.org/XML/1998/namespace}id": bibl_id})
    ET.SubElement(bibl, "date", date_attribs)
    sender_ref = f"#emt_person_id__{sender['id']}" if type(sender["id"]) == int else sender["id"]
    ET.SubElement(bibl, "persName", ref=sender_ref,role="sender").text = sender["value"]
    recipient_ref =f"#emt_person_id__{recipient['id']}" if type(recipient["id"]) == int else recipient["id"]
    ET.SubElement(bibl, "persName", ref=recipient_ref,role="recipient").text = recipient["value"]
    
files = sorted(glob.glob("./data/editions/*.xml", recursive=True))
mentions_data = requests.get(
    "https://raw.githubusercontent.com/emt-project/emt-entities/refs/heads/main/json_dumps/mentioned_letters.json"
).json()

for x in files:
    doc = TeiReader(x)
    if doc.any_xpath("//tei:ref[not(ancestor::tei:note) and not(ancestor::tei:correspContext)]"):
        #add a listBibl to the back
        list_bibl = doc.any_xpath("//tei:back/tei:listBibl")
        if len(list_bibl) == 0:
            list_bibl = ET.SubElement(doc.any_xpath(".//tei:back")[0],
                            "listBibl", type="mentionedLetters"
                        )
        else:
            list_bibl = list_bibl[0]
            print(f"listBibl already exists in {x}")
        unique_letters = set()
        for y in doc.any_xpath("//tei:ref[not(ancestor::tei:note) and not(ancestor::tei:correspContext) and @target]"):
            targets = y.get("target").split()
            # prefix for mentions in the Baserow table
            br_prefix = "#emt_letter_id__"
            for target in targets:
                try:
                    if target.startswith(br_prefix):
                        mention_id = target.removeprefix(br_prefix)
                        if mention_id in mentions_data and mention_id not in unique_letters:
                            mention_info = mentions_data[mention_id]
                            date_attribs = {}
                            if mention_info.get("when"):
                                date_attribs["when-iso"] = mention_info["when"]
                            else:
                                if mention_info.get("not_before"):
                                    date_attribs["notBefore"] = mention_info["not_before"]
                                if mention_info.get("not_after"):
                                    date_attribs["notAfter"] = mention_info["not_after"]
                            sender = mention_info["sender"][0]
                            recipient = mention_info["recipient"][0]
                            build_bibl_entry(list_bibl, f"emt_letter_id__{mention_id}", date_attribs, sender, recipient)
                    elif target.endswith(".xml"):
                        mention_id = target.removeprefix("#").removesuffix(".xml")
                        if mention_id not in unique_letters:
                            mentioned_doc_path = f"./data/editions/{mention_id}.xml"
                            if not os.path.exists(mentioned_doc_path):
                                print(f"Referenced file {mentioned_doc_path} does not exist.")
                                continue
                            mentioned_doc = TeiReader(mentioned_doc_path)
                            title = mentioned_doc.any_xpath(".//tei:titleStmt/tei:title[1]/text()")
                            date_attribs = {}
                            sent_date = mentioned_doc.any_xpath(".//tei:correspDesc/tei:correspAction[@type='sent']/tei:date")
                            if sent_date:
                                date_element = sent_date[0]
                                for attr in ["when-iso", "notBefore", "notAfter"]:
                                    if date_element.get(attr):
                                        date_attribs[attr] = date_element.get(attr)
                            sender_element = mentioned_doc.any_xpath(".//tei:correspDesc/tei:correspAction[@type='sent']/tei:persName")
                            recipient_element = mentioned_doc.any_xpath(".//tei:correspDesc/tei:correspAction[@type='received']/tei:persName")
                            sender = {"id": sender_element[0].get("ref"), "value": sender_element[0].text}
                            recipient = {"id": recipient_element[0].get("ref"), "value": recipient_element[0].text}
                            build_bibl_entry(list_bibl, mention_id, date_attribs, sender, recipient)
                    else:
                        print(f"Target '{target}' in file {x} does not match expected format.")
                        continue
                       
                    unique_letters.add(mention_id)     
                    
                except Exception as e:
                    print(f"Error processing target '{target}' in file {x}: {e}")
                    continue
    doc.tree_to_file(x)