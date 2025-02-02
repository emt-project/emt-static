import glob
from rdflib import Graph

from acdh_cidoc_pyutils import teidoc_as_f24_publication_expression


files = glob.glob("./data/editions/*.xml")
domain = "https://kaiserin-eleonora.oeaw.ac.at"

g = Graph()
for x in files:
    uri, cur_graph, mentions = teidoc_as_f24_publication_expression(
        x, domain, add_mentions=True
    )

g.serialize("html/cidoc.ttl", format="ttl", encoding="utf-8")
