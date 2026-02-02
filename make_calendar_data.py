import json
import os
import glob
import requests
import pandas as pd
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import normalize_string
from acdh_cidoc_pyutils import extract_begin_end

print("creating calendar data")
file_list = sorted(glob.glob("./data/editions/*.xml"))
mentions_data = requests.get(
    "https://raw.githubusercontent.com/emt-project/emt-entities/refs/heads/main/json_dumps/mentions.json"
).json()
data_dir = os.path.join("html", "js-data")
os.makedirs(data_dir, exist_ok=True)
out_file = os.path.join(data_dir, "calendarData.json")
broken = []
events = []
owned_mentions = []
sender = set()
main_sender_ids = [
    "emt_person_id__9",
    "emt_person_id__18",
    "emt_person_id__50",
]
mentions_sender_info = {
    "50": {
        "label": "erwähnter Brief von Philipp Wilhelm von Pfalz-Neuburg",
        "kind": "mentioned_letter_pw",
    },
    "18": {
        "label": "erwähnter Brief von Johann Wilhelm von Pfalz-Neuburg",
        "kind": "mentioned_letter_jw",
    },
}
for x in file_list:
    f_id = os.path.split(x)[1].replace(".xml", ".html")
    item = {"link": f_id}
    doc = TeiReader(x)
    title_node = doc.any_xpath(
        ".//tei:fileDesc/tei:titleStmt/tei:title[@type='main'][1]//text()"
    )[0]

    try:
        sent_date_node = doc.any_xpath("//tei:correspAction/tei:date")[0]
    except IndexError:
        broken.append(f"missing '//tei:correspAction/tei:date' in file: {x}")
        continue
    dates = extract_begin_end(sent_date_node)
    if dates[0]:
        item["date"] = dates[0]
        item["from"] = dates[0]
        item["to"] = dates[1]
        if dates[0] == dates[1]:
            item["range"] = False
        else:
            item["range"] = True
        title = normalize_string(title_node)
        item["label"] = title
        sender_name = normalize_string(
            doc.any_xpath(".//tei:correspAction[@type='sent']/tei:persName//text()")[0]
        )
        try:
            sender_id = doc.any_xpath(
                ".//tei:correspAction[@type='sent']/tei:persName/@ref"
            )[0]
        except IndexError:
            print(
                f"### BROKEN: {x}, no .//tei:correspAction[@type='sent']/tei:persName/@ref provided"
            )
            continue
        # Determine the relevant ID for categorization
        # If sender is EMT (id 9), use recipient; otherwise use sender
        if sender_id == "#emt_person_id__9":
            try:
                relevant_id = doc.any_xpath(
                    ".//tei:correspAction[@type='received']/tei:persName/@ref"
                )[0][1:]
            except IndexError:
                print(
                    f"### BROKEN: {x}, no .//tei:correspAction[@type='received']/tei:persName/@ref provided"
                )
                continue
        else:
            relevant_id = sender_id[1:]
        # letters not sent by EMT, JW or PW or by EMT to someone other than JW or PW are categorized as "drittbriefe"      
        if relevant_id not in main_sender_ids:
            item["kind"] = "drittbriefe"
        else:
            item["kind"] = f"{sender_id[1:]}.html"
        item["sender"] = {"label": sender_name, "link": f"{sender_id[1:]}.html"}
        events.append(item)
    else:
        pass
    # prefix for mentions in the Baserow table
    br_prefix = "#emt_mention_id__"
    for y in doc.any_xpath("//tei:body//tei:ref[not(ancestor::tei:note)]"):
        targets = y.get("target").split()
        for target in targets:
            if target.startswith(br_prefix):
                mention_id = target.removeprefix(br_prefix)
                if mention_id in mentions_data:
                    sender_id = str(mentions_data[mention_id]["sender"][0]["id"])
                    extra_item = {
                        "link": False,
                        "label": mentions_sender_info.get(sender_id, {}).get(
                            "label", "erwähnter Brief"
                        ),
                        "kind": mentions_sender_info.get(sender_id, {}).get(
                            "kind", "mentioned_letter_other"
                        ),
                        "ref_by": {"label": title, "link": f_id},
                    }
                mention_info = mentions_data[mention_id]
                if mention_info["when"] is not None:
                    extra_item["date"] = mention_info["when"]
                else:
                    extra_item["from"] = mention_info["not_before"]
                    extra_item["to"] = mention_info["not_after"]
                events.append(extra_item)
            else:
                owned_mentions.append(
                    {
                        "link": target[1:].replace(".xml", ".html"),
                        "ref_by": {"label": title, "link": f_id},
                    }
                )


mentioned_letters = requests.get(
    "https://raw.githubusercontent.com/emt-project/emt-entities/refs/heads/main/json_dumps/mentioned_letters.json"
).json()  # noqa:

for key, value in mentioned_letters.items():
    try:
        sender = value["sender"][0]["value"].split(", ")[0]
    except IndexError:
        print(value)
        continue
    receiver = value["receiver"][0]["value"].split(", ")[0]
    date_written = value["date_written"]
    event = {
        "link": False,
        "label": f"Erschlossener Brief – {sender} an {receiver} ({date_written})",
        "date": value["not_before"],
        "kind": "Brief_erschlossen",
    }
    events.append(event)

# add owned mentions within events
for mention in owned_mentions:
    for event in events:
        if event.get("link") == mention["link"]:
            event["ref_by"] = mention["ref_by"]

with open(out_file, "w", encoding="utf-8") as f:
    json.dump(events, f, ensure_ascii=False, indent=2)


df = pd.DataFrame(events)
df.to_csv("hansi.csv", index=False)
print(f"saving calendar data as {out_file}")
