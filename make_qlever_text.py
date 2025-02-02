import glob
import os
import pandas as pd
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import check_for_hash, extract_fulltext

print("convert a directory of TEI files into qlever words- and docsfile")

tag_blacklist = [
    "{http://www.tei-c.org/ns/1.0}note",
    "{http://www.tei-c.org/ns/1.0}abbr",
    "{http://www.tei-c.org/ns/1.0}del",
]
domain = "https://kaiserin-eleonora.oeaw.ac.at"
files = sorted(glob.glob("./data/editions/*.xml"))
words_data = []
docs_data = []
for x in sorted(files):
    doc_id = f"<{domain}/{os.path.split(x)[-1]}> "
    doc = TeiReader(x)
    text = extract_fulltext(
        doc.any_xpath(".//tei:body")[0], tag_blacklist=tag_blacklist
    )
    if len(text) > 3:
        docs_data.append((doc_id, text))
        for y in doc.any_xpath(".//tei:rs[@ref]"):
            ent_id = y.attrib["ref"].split(" ")[
                0
            ]  # I guess we can't deal with multiple entities
            ent_uri = f"<{domain}/{check_for_hash(ent_id)}> "
            y.text = ent_uri
        text = extract_fulltext(
            doc.any_xpath(".//tei:body")[0], tag_blacklist=tag_blacklist
        )
        data = [(x, 0, doc_id, 1) for x in text.split()]
        words_data.extend(data)

words_df = pd.DataFrame(words_data, columns=("token", "entity", "doc_id", "score"))
words_df["entity"] = words_df.apply(
    lambda row: 1 if domain in row["token"] else row["entity"], axis=1
)
words_df.to_csv("html/wordsfile.tsv", sep="\t", index=False, header=False)

docs_df = pd.DataFrame(docs_data, columns=["record_id", "text"])
docs_df.to_csv("html/docsfile.tsv", sep="\t", index=False, header=False)
