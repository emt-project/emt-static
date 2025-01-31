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

<https://foo/bar> acdh:hasLicensor <https://id.acdh.oeaw.ac.at/oeawihb> ;
    acdh:hasOwner <https://id.acdh.oeaw.ac.at/oeawihb> ;
    acdh:hasRightsHolder <https://id.acdh.oeaw.ac.at/oeaw> .
"""
ihb_owner_graph = Graph().parse(data=ihb_owner)


files = sorted(glob.glob("data/editions/*.xml"))
selected_files = (
    files[:3] + files[len(files) // 2 - 1: len(files) // 2 + 2] + files[-3:]
)
# files = selected_files
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
    g.add(
        (cur_doc_uri, ACDH["hasCreator"], URIRef("https://id.acdh.oeaw.ac.at/kkeller"))
    )
    g.add(
        (cur_doc_uri, ACDH["hasCreator"], URIRef("https://id.acdh.oeaw.ac.at/ipeper"))
    )
    g.add(
        (
            cur_doc_uri,
            ACDH["hasCreator"],
            URIRef("https://id.acdh.oeaw.ac.at/aspitzbart"),
        )
    )
    g.add(
        (
            cur_doc_uri,
            ACDH["hasContributor"],
            URIRef("https://d-nb.info/gnd/1043833846"),
        )
    )
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
    for i, image in enumerate(
        doc.any_xpath(".//tei:facsimile/tei:surface/tei:graphic[@url]"), start=1
    ):
        cur_image_id = f"{cur_col_id}___{i:04}.jpg"
        cur_image_uri = URIRef(f"{TOP_COL_URI}/{cur_image_id}")

        try:
            repo = extract_fulltext(doc.any_xpath(".//tei:msIdentifier")[0])
        except IndexError:
            repo = "whatever"

        if "Karlsruhe" in repo:
            owner_uri = URIRef("https://d-nb.info/gnd/1014584-9")
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasLicense"],
                    URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/noc-oklr"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasRightsHolder"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasDigitisingAgent"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasRightsHolder"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasOwner"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasOwner"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasLicensor"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasLicensor"],
                    URIRef("https://d-nb.info/gnd/1014584-9"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasRightsInformation"],
                    Literal(
                        "Jedwede Nachnutzung des Bilddigitalisates bedarf einer schriftlichen Genehmigung seitens des Generallandesarchivs Karlsruhe.",  # noqa
                        lang="de",
                    ),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasRightsInformation"],
                    Literal(
                        "Any re-use of the digitised images requires written permission from the Generallandesarchiv Karlsruhe.",  # noqa
                        lang="en",
                    ),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasRightsInformation"],
                    Literal(
                        "Jedwede Nachnutzung der Bilddigitalisate bedarf einer schriftlichen Genehmigung seitens des Generallandesarchivs Karlsruhe.",  # noqa
                        lang="de",
                    ),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasRightsInformation"],
                    Literal(
                        "Any re-use of the digitised images requires written permission from the Generallandesarchiv Karlsruhe.",  # noqa
                        lang="en",
                    ),
                )
            )
        elif "Korrespondenzakten" in repo:
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasLicense"],
                    URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/cc0-1-0"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasLicensor"],
                    URIRef("https://id.acdh.oeaw.ac.at/oeawihb"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasOwner"],
                    URIRef("https://d-nb.info/gnd/4655277-7"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasOwner"],
                    URIRef("https://d-nb.info/gnd/4655277-7"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasRightsHolder"],
                    URIRef("https://id.acdh.oeaw.ac.at/none"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasRightsHolder"],
                    URIRef("https://id.acdh.oeaw.ac.at/none"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasDigitisingAgent"],
                    URIRef("https://d-nb.info/gnd/4655277-7"),
                )
            )
        else:
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasLicense"],
                    URIRef("https://vocabs.acdh.oeaw.ac.at/archelicenses/cc0-1-0"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasLicensor"],
                    URIRef("https://id.acdh.oeaw.ac.at/oeawihb"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasOwner"],
                    URIRef("https://d-nb.info/gnd/2005486-5"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasOwner"],
                    URIRef("https://d-nb.info/gnd/2005486-5"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasRightsHolder"],
                    URIRef("https://id.acdh.oeaw.ac.at/none"),
                )
            )
            g.add(
                (
                    cur_col_uri,
                    ACDH["hasRightsHolder"],
                    URIRef("https://id.acdh.oeaw.ac.at/none"),
                )
            )
            g.add(
                (
                    cur_image_uri,
                    ACDH["hasDigitisingAgent"],
                    URIRef("https://d-nb.info/gnd/2005486-5"),
                )
            )
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
        g.add(
            (
                cur_doc_uri,
                ACDH["hasCreator"],
                URIRef("https://id.acdh.oeaw.ac.at/kkeller"),
            )
        )
        g.add(
            (
                cur_doc_uri,
                ACDH["hasCreator"],
                URIRef("https://id.acdh.oeaw.ac.at/ipeper"),
            )
        )
        g.add(
            (
                cur_doc_uri,
                ACDH["hasCreator"],
                URIRef("https://id.acdh.oeaw.ac.at/aspitzbart"),
            )
        )
        g.add(
            (
                cur_doc_uri,
                ACDH["hasContributor"],
                URIRef("https://d-nb.info/gnd/1043833846"),
            )
        )
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

print(f"copy title image into {to_ingest}")
shutil.copy(
    "./html/bio-pics/emt_person_id__9.jpg", os.path.join(to_ingest, "title-image.jpg")
)
