import glob
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext
from tqdm import tqdm
from slugify import slugify

files = sorted(glob.glob("./data/editions/*.xml"))
print(f"adding revisionDesc @status and @n values for {len(files)} documents")

for x in tqdm(files):
    doc_status = ""
    doc = TeiReader(x)
    fulltext = extract_fulltext(doc.any_xpath(".//tei:body")[0])
    if fulltext:
        doc_status += "Volltext; "
    rs_tags = doc.any_xpath(".//tei:body//tei:rs")
    if rs_tags:
        doc_status += "Entitäten; "
    try:
        regest = extract_fulltext(doc.any_xpath(".//tei:abstract[@n='regest']")[0])
    except IndexError:
        print(f"problematic TEI Header in file: {x}")
        continue
    if regest:
        doc_status += "Regest; "
    if not doc_status:
        doc_status = "in Bearbeitung;"
    doc_status = doc_status.strip()
    if doc_status[-1] == ";":
        doc_status = doc_status[:-1]
    try:
        revision_desc = doc.any_xpath(".//tei:revisionDesc")[0]
        revision_desc.attrib["status"] = slugify(doc_status)
        revision_desc.attrib["n"] = doc_status
    except IndexError:
        print(f"missing tei:revisionDesc in {x}")
    doc.tree_to_file(x)
