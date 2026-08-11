import copy
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
    body = doc.any_xpath(".//tei:body")[0]
    # remove attachments from body for fulltext extraction
    body_copy = copy.deepcopy(body)
    for attachment in body_copy.findall(".//tei:div[@type='attachment']", {"tei": "http://www.tei-c.org/ns/1.0"}):
        attachment.getparent().remove(attachment)
    fulltext = extract_fulltext(body_copy, ["{http://www.tei-c.org/ns/1.0}head"])
    if fulltext:
        doc_status += "Volltext; "
    try:
        regest = extract_fulltext(doc.any_xpath(".//tei:abstract[@n='regest']")[0])
    except IndexError:
        print(f"No abstract[@n='regest'] element in {x}")
        regest = ""
    if regest:
        doc_status += "Regest; "
    rs_tags = doc.any_xpath(".//tei:body//tei:rs[not(ancestor::tei:div[@type='attachment'])] | .//tei:abstract[@n='regest']//tei:rs")
    if rs_tags:
        doc_status += "Entitäten; "
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
