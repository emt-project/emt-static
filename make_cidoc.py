import glob
from rdflib import Graph, URIRef

from acdh_cidoc_pyutils import teidoc_as_f24_publication_expression
from acdh_cidoc_pyutils.namespaces import CIDOC


files = glob.glob("./data/editions/*.xml")
domain = "https://kaiserin-eleonora.oeaw.ac.at"

g = Graph()
for x in files:
    uri, cur_graph, mentions = teidoc_as_f24_publication_expression(
        x, domain, add_mentions=True
    )
    # for m in mentions:
    #     g.add(
    #         (
    #             uri, CIDOC["P67_refers_to"], URIRef(f"{domain}/{m[0]}")
    #         )
    #     )
    #     g.add(
    #         (
    #             URIRef(f"{domain}/{m[0]}"), CIDOC["P67i_is_referred_to_by"], uri
    #         )
    #     )
    g += cur_graph

g.serialize("html/cidoc.ttl", format="ttl", encoding="utf-8")
