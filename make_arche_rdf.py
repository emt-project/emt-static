import glob
import os
import shutil
from tqdm import tqdm
from acdh_cidoc_pyutils import extract_begin_end
from acdh_tei_pyutils.tei import TeiReader
from acdh_tei_pyutils.utils import extract_fulltext, make_entity_label, get_xmlid
from rdflib import Namespace, URIRef, RDF, Graph, Literal, XSD

print("generating ARCHE-Metadata")
to_ingest = "to_ingest"
os.makedirs(to_ingest, exist_ok=True)

g = Graph().parse("arche_seed_files/arche_constants.ttl")
g_repo_objects = Graph().parse("arche_seed_files/repo_objects_constants.ttl")
TOP_COL_URI = URIRef("https://id.acdh.oeaw.ac.at/emt")
APP_URL = "https://kaiserin-eleonora.oeaw.ac.at/"

ACDH = Namespace("https://vocabs.acdh.oeaw.ac.at/schema#")
COLS = [ACDH["TopCollection"], ACDH["Collection"], ACDH["Resource"]]
COL_URIS = set()
ihb_owner = """
@prefix acdh: <https://vocabs.acdh.oeaw.ac.at/schema#> .

<https://foo/bar> acdh:hasLicensor <https://d-nb.info/gnd/1202798799> ;
    acdh:hasOwner <https://d-nb.info/gnd/1202798799> ;
    acdh:hasRightsHolder <https://d-nb.info/gnd/1202798799> .
"""
ihb_owner_graph = Graph().parse(data=ihb_owner)

for p, o in ihb_owner_graph.predicate_objects():
    g.add((TOP_COL_URI, p, o))


files = sorted(glob.glob("data/editions/*.xml"))[:5]
for x in tqdm(files):
    doc = TeiReader(x)
    cur_col_id = os.path.split(x)[-1].replace(".xml", "")
    cur_doc_id = f"{cur_col_id}.xml"

    # document collection
    cur_col_uri = URIRef(f"{TOP_COL_URI}/{cur_col_id}")
    g.add((cur_col_uri, RDF.type, ACDH["Collection"]))
    g.add((cur_col_uri, ACDH["isPartOf"], TOP_COL_URI))
    for p, o in ihb_owner_graph.predicate_objects():
        g.add((cur_col_uri, p, o))

    # TEI/XML Document
    cur_doc_uri = URIRef(f"{TOP_COL_URI}/{cur_doc_id}")
    g.add((cur_doc_uri, RDF.type, ACDH["Resource"]))
    g.add((cur_doc_uri, ACDH["isPartOf"], cur_col_uri))
    g.add(
        (
            cur_doc_uri,
            ACDH["hasUrl"],
            Literal(
                f"{APP_URL}{cur_doc_id.replace(".xml", ".html")}", datatype=XSD.anyURI
            ),
        )
    )
    g.add(
        (
            cur_doc_uri,
            ACDH["hasLicense"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"),
        )
    )
    for p, o in ihb_owner_graph.predicate_objects():
        g.add((cur_doc_uri, p, o))

    # title
    title = extract_fulltext(
        doc.any_xpath(".//tei:titleStmt/tei:title[@type='main']")[0]
    )
    g.add((cur_col_uri, ACDH["hasTitle"], Literal(title, lang="de")))
    g.add(
        (
            cur_doc_uri,
            ACDH["hasTitle"],
            Literal(f"TEI/XML Dokument: {title}", lang="de"),
        )
    )
    g.add(
        (
            cur_doc_uri,
            ACDH["hasCategory"],
            URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"),
        )
    )

    # hasNonLinkedIdentifier
    repo_str = extract_fulltext(
        doc.any_xpath(".//tei:msIdentifier[1]//tei:repository[1]")[0]
    )
    idno_str = extract_fulltext(doc.any_xpath(".//tei:msIdentifier[1]//tei:idno[1]")[0])
    non_linked_id = f"{repo_str}, {idno_str}"
    g.add(
        (cur_col_uri, ACDH["hasNonLinkedIdentifier"], Literal(non_linked_id, lang="de"))
    )
    g.add(
        (cur_doc_uri, ACDH["hasNonLinkedIdentifier"], Literal(non_linked_id, lang="de"))
    )

    # start/end date
    try:
        start, end = extract_begin_end(
            doc.any_xpath(".//tei:correspAction[@type='sent']/tei:date")[0]
        )
    except IndexError:
        start, end = False, False
    if start:
        g.add(
            (
                cur_col_uri,
                ACDH["hasCoverageStartDate"],
                Literal(start, datatype=XSD.date),
            )
        )
        g.add(
            (
                cur_doc_uri,
                ACDH["hasCoverageStartDate"],
                Literal(start, datatype=XSD.date),
            )
        )
    if end:
        g.add(
            (cur_col_uri, ACDH["hasCoverageEndDate"], Literal(end, datatype=XSD.date))
        )
        g.add(
            (cur_doc_uri, ACDH["hasCoverageEndDate"], Literal(start, datatype=XSD.date))
        )

    # actors (persons):
    for y in doc.any_xpath(
        ".//tei:back//tei:person[@xml:id and ./tei:idno[@type='GND']]"
    ):
        xml_id = get_xmlid(y)
        entity_title = make_entity_label(y.xpath("./*[1]")[0])[0]
        entity_id = y.xpath("./*[@type='GND']/text()")[0]
        entity_uri = URIRef(entity_id)
        g.add((entity_uri, RDF.type, ACDH["Person"]))
        g.add(
            (
                entity_uri,
                ACDH["hasUrl"],
                Literal(f"{APP_URL}{xml_id}", datatype=XSD.anyURI),
            )
        )
        g.add((entity_uri, ACDH["hasTitle"], Literal(entity_title, lang="und")))
        g.add((cur_col_uri, ACDH["hasActor"], entity_uri))
        g.add((cur_doc_uri, ACDH["hasActor"], entity_uri))

    # actors (orgs):
    for y in doc.any_xpath(".//tei:back//tei:org[@xml:id and ./tei:idno[@type='GND']]"):
        xml_id = get_xmlid(y)
        entity_title = make_entity_label(y.xpath("./*[1]")[0])[0]
        entity_id = y.xpath("./*[@type='GND']/text()")[0]
        entity_uri = URIRef(entity_id)
        g.add((entity_uri, RDF.type, ACDH["Organisation"]))
        g.add(
            (
                entity_uri,
                ACDH["hasUrl"],
                Literal(f"{APP_URL}{xml_id}", datatype=XSD.anyURI),
            )
        )
        g.add((entity_uri, ACDH["hasTitle"], Literal(entity_title, lang="und")))
        g.add((cur_col_uri, ACDH["hasActor"], entity_uri))
        g.add((cur_doc_uri, ACDH["hasActor"], entity_uri))

    # spatial coverage:
    for y in doc.any_xpath(
        ".//tei:back//tei:place[@xml:id and ./tei:idno[@type='GEONAMES']]"
    ):
        xml_id = get_xmlid(y)
        entity_title = make_entity_label(y.xpath("./*[1]")[0])[0]
        entity_id = y.xpath("./*[@type='GEONAMES']/text()")[0]
        entity_uri = URIRef(entity_id)
        g.add((entity_uri, RDF.type, ACDH["Place"]))
        g.add(
            (
                entity_uri,
                ACDH["hasUrl"],
                Literal(f"{APP_URL}{xml_id}", datatype=XSD.anyURI),
            )
        )
        g.add((entity_uri, ACDH["hasTitle"], Literal(entity_title, lang="und")))
        g.add((cur_col_uri, ACDH["hasSpatialCoverage"], entity_uri))
        g.add((cur_doc_uri, ACDH["hasSpatialCoverage"], entity_uri))

    # hasExtent
    nr_of_images = len(doc.any_xpath(".//tei:facsimile/tei:surface/tei:graphic[@url]"))
    g.add(
        (cur_doc_uri, ACDH["hasExtent"], Literal(f"{nr_of_images} Blätter", lang="de"))
    )

    # images
    try:
        repo = doc.any_xpath(".//tei:repository/text()")[0]
    except IndexError:
        owner_uri = URIRef("https://d-nb.info/gnd/2005486-5")
        repo = "whatever"

    if "Karlsruhe" in repo:
        owner_uri = URIRef("https://d-nb.info/gnd/1014584-9")
    elif "korrespondenz" in x:
        owner_uri = URIRef("https://d-nb.info/gnd/4655277-7")
    else:
        owner_uri = URIRef("https://d-nb.info/gnd/2005486-5")

    for i, image in enumerate(
        doc.any_xpath(".//tei:facsimile/tei:surface/tei:graphic[@url]"), start=1
    ):
        cur_image_id = f"{cur_col_id}___{i:04}.jpg"
        cur_image_uri = URIRef(f"{TOP_COL_URI}/{cur_image_id}")
        g.add((cur_image_uri, RDF.type, ACDH["Resource"]))
        g.add((cur_image_uri, ACDH["isPartOf"], cur_col_uri))
        g.add(
            (
                cur_image_uri,
                ACDH["hasCategory"],
                URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/image"),
            )
        )
        g.add((cur_image_uri, ACDH["hasTitle"], Literal(f"{cur_image_id}", lang="und")))
        g.add(
            (
                cur_image_uri,
                ACDH["hasLicense"],
                URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/noc-oklr"),
            )
        )
        g.add((cur_image_uri, ACDH["hasLicensor"], owner_uri))
        g.add((cur_image_uri, ACDH["hasOwner"], owner_uri))
        g.add((cur_image_uri, ACDH["hasRightsHolder"], owner_uri))
        if i != nr_of_images:
            next_uri = URIRef(f"{TOP_COL_URI}/{cur_col_id}___{i + 1:04}.jpg")
            g.add((cur_image_uri, ACDH["hasNextItem"], next_uri))
        else:
            next_uri = URIRef(f"{TOP_COL_URI}/{cur_col_id}.xml")
            g.add((cur_image_uri, ACDH["hasNextItem"], next_uri))
    g.add(
        (
            cur_col_uri,
            ACDH["hasNextItem"],
            URIRef(f"{TOP_COL_URI}/{cur_col_id}___0001.jpg"),
        )
    )

# indices and meta
for y in ["indices", "meta"]:
    for x in glob.glob(f"./data/{y}/*.xml"):
        doc = TeiReader(x)
        cur_doc_id = os.path.split(x)[-1]
        cur_doc_uri = URIRef(f"{TOP_COL_URI}/{cur_doc_id}")
        g.add((cur_doc_uri, RDF.type, ACDH["Resource"]))
        g.add((cur_doc_uri, ACDH["isPartOf"], URIRef(f"{TOP_COL_URI}/{y}")))
        g.add(
            (
                cur_doc_uri,
                ACDH["hasLicense"],
                URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/cc-by-4-0"),
            )
        )
        title = extract_fulltext(doc.any_xpath(".//tei:titleStmt/tei:title[1]")[0])
        g.add(
            (
                cur_doc_uri,
                ACDH["hasTitle"],
                Literal(f"TEI/XML Dokument: {title}", lang="de"),
            )
        )
        g.add(
            (
                cur_doc_uri,
                ACDH["hasCategory"],
                URIRef("https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"),
            )
        )
        for p, o in ihb_owner_graph.predicate_objects():
            g.add((cur_doc_uri, p, o))


for x in COLS:
    for s in g.subjects(None, x):
        COL_URIS.add(s)

for x in COL_URIS:
    for p, o in g_repo_objects.predicate_objects():
        g.add((x, p, o))

g.parse("./arche_seed_files/other_things.ttl")

print("writing graph to file")
g.serialize("html/arche.ttl")

shutil.copy("html/arche.ttl", os.path.join(to_ingest, "arche.ttl"))

files_to_ingest = glob.glob("./data/*/*.xml")
print(f"copying {len(files_to_ingest)} into {to_ingest}")
for x in files_to_ingest:
    _, tail = os.path.split(x)
    new_name = os.path.join(to_ingest, tail)
    shutil.copy(x, new_name)

# following commented lines would add tei-schema to tei files; but this makes the filechecker run taking > 6 hours, and I batch validated the files with oxygen anyways
# old_string = """<?xml version='1.0' encoding='UTF-8'?>
# <TEI xmlns="http://www.tei-c.org/ns/1.0" """

# new_string = """<?xml version="1.0" encoding="UTF-8"?>
# <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
# <?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
# <TEI xmlns="http://www.tei-c.org/ns/1.0" """  # noqa:

# # files = sorted(glob.glob("to_ingest/*.xml"))

# # for x in files:
# #     with open(x, "r", encoding="utf-8") as file:
# #         content = file.read()
# #         updated_content = content.replace(old_string, new_string)
# #     with open(x, "w", encoding="utf-8") as file:
# #         file.write(updated_content)


print(f"copy title image into {to_ingest}")
shutil.copy("./html/bio-pics/emt_person_id__9.jpg", os.path.join(to_ingest, "title-image.jpg"))
