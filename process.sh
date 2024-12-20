python sender_receiver.py
add-attributes -g "./data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at.at/emt"
add-attributes -g "./data/meta/*.xml" -b "https://id.acdh.oeaw.ac.at.at/emt"
denormalize-indices -f "./data/editions/*.xml" -i "./data/indices/*.xml" -m ".//*[@ref]/@ref | .//*/@source" -x ".//tei:titleStmt/tei:title[@type='main']/text()"
python rm_listevent.py
python add_correspContext.py
python add_revisiondesc_status.py
python make_calendar_data.py
python make_cmif.py
python make_translations.py
python fix_facs.py
# python make_arche_rdf.py