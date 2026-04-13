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
mentioned_letters_data = requests.get(
    "https://raw.githubusercontent.com/emt-project/emt-entities/refs/heads/main/json_dumps/mentioned_letters.json"
).json()
data_dir = os.path.join("html", "js-data")
os.makedirs(data_dir, exist_ok=True)
out_file = os.path.join(data_dir, "calendarData.json")
broken = []
events = []
owned_mentions = []
sender = set()
main_correspondent_ids = [
    "emt_person_id__9",
    "emt_person_id__18",
    "emt_person_id__50",
]
mentions_sender_info = {
    "9": {
        "label": "erwähnter Brief von Eleonora Magdalena von Pfalz-Neuburg",
        "kind": "mentioned_letter_emt",
    },
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
    try:
        f_id = os.path.split(x)[1].replace(".xml", ".html")
        item = {"link": f_id}
        doc = TeiReader(x)

        title_nodes = doc.any_xpath(
            ".//tei:fileDesc/tei:titleStmt/tei:title[@type='main'][1]//text()"
        )
        if not title_nodes:
            broken.append(f"missing title in file: {x}")
            continue
        title_node = title_nodes[0]

        sent_date_nodes = doc.any_xpath("//tei:correspAction/tei:date")
        if not sent_date_nodes:
            broken.append(f"missing '//tei:correspAction/tei:date' in file: {x}")
            continue
        sent_date_node = sent_date_nodes[0]

        dates = extract_begin_end(sent_date_node)
        if dates[0]:
            item["date"] = dates[0]
            item["from"] = dates[0]
            item["to"] = dates[1]
            item["range"] = dates[0] != dates[1]

            title = normalize_string(title_node)
            item["label"] = title

            sender_names = doc.any_xpath(
                ".//tei:correspAction[@type='sent']/tei:persName//text()"
            )
            if not sender_names:
                broken.append(f"missing sender name in file: {x}")
                continue
            sender_name = normalize_string(sender_names[0])

            sender_ids = doc.any_xpath(
                ".//tei:correspAction[@type='sent']/tei:persName/@ref"
            )
            if not sender_ids:
                broken.append(f"missing sender id in file: {x}")
                continue
            sender_id = sender_ids[0].lstrip("#")

            # everything that is not sent by the main correspondents is categorized as "drittbriefe"
            sender_is_main = sender_id in main_correspondent_ids
            if not sender_is_main:
                item["kind"] = "drittbriefe"
            else:
                recipient_ids = doc.any_xpath(
                    ".//tei:correspAction[@type='received']/tei:persName/@ref"
                )
                if not recipient_ids:
                    broken.append(f"missing recipient id in file: {x}")
                    continue
                recipient_id = recipient_ids[0].lstrip("#")
                recipient_is_main = recipient_id in main_correspondent_ids
                item["kind"] = (
                    f"{sender_id}.html" if recipient_is_main else "drittbriefe"
                )

            item["sender"] = {"label": sender_name, "link": f"{sender_id}.html"}
            events.append(item)

        # prefix for mentions in the Baserow table
        br_prefix = "#emt_letter_id__"
        for y in doc.any_xpath(
            "//tei:ref[not(ancestor::tei:note) and not(ancestor::tei:correspContext) and @target]"
        ):
            target_attr = y.get("target")
            if not target_attr:
                continue
            targets = target_attr.split()
            for target in targets:
                try:
                    if target.startswith(br_prefix):
                        mention_id = target.removeprefix(br_prefix)
                        if mention_id not in mentioned_letters_data:
                            print(
                                f"Warning: mention_id '{mention_id}' not found (file: {x})"
                            )
                            continue
                        sender_list = mentioned_letters_data[mention_id].get(
                            "sender", []
                        )
                        if not sender_list:
                            print(
                                f"Warning: no sender for mention_id '{mention_id}' (file: {x})"
                            )
                            continue
                        sender_id = str(sender_list[0]["id"])
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
                        mention_info = mentioned_letters_data[mention_id]
                        if mention_info.get("when"):
                            extra_item["date"] = mention_info["when"]
                        elif mention_info.get("not_before") and mention_info.get(
                            "not_after"
                        ):
                            extra_item["from"] = mention_info["not_before"]
                            extra_item["to"] = mention_info["not_after"]
                        else:
                            print(
                                f"Warning: no date for mention_id '{mention_id}' (file: {x})"
                            )
                            continue
                        events.append(extra_item)
                    else:
                        owned_mentions.append(
                            {
                                "link": target[1:].replace(".xml", ".html"),
                                "ref_by": {"label": title, "link": f_id},
                            }
                        )
                except Exception as e:
                    print(f"Error processing target '{target}' in file {x}: {e}")
                    continue

    except Exception as e:
        broken.append(f"Error processing file {x}: {e}")
        continue


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
