import glob
import os
from acdh_tei_pyutils.tei import TeiReader

print("fixing facs attributes")

files = sorted(glob.glob("./data/editions/*.xml"))
ARCHE_ID = "https://id.acdh.oeaw.ac.at/emt/"

for x in files:
    doc = TeiReader(x)
    f_id = os.path.split(x)[-1].replace(".xml", "")
    for i, y in enumerate(doc.any_xpath(".//tei:graphic"), start=1):
        old_url = y.attrib["url"]
        new_url = f"{ARCHE_ID}{f_id}___{i:04}.jpg"
        y.attrib["url"] = new_url
        y.attrib["n"] = old_url
    for i, y in enumerate(doc.any_xpath(".//tei:pb"), start=1):
        new_url = f"{ARCHE_ID}{f_id}___{i:04}.jpg"
        del y.attrib["{http://www.w3.org/XML/1998/namespace}id"]
        try:
            del y.attrib["id"]
        except:
            pass
        old_facs = y.attrib["facs"]
        new_facs = f"{old_facs} {new_url}"
        y.attrib["facs"] = new_facs
    doc.tree_to_file(x)
