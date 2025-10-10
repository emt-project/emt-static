<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:template name="info_modal">
        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="exampleModalLabel">Erläuterungen zum Textkritischen Markup</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"></button>
                    </div>
                    <div class="modal-body">
                        <dl>
                            <dt>Entitäten</dt>
                            <dd class="ps-2">Entitäten wie <span class="entity entity-person">Personen</span>,                                <span class="entity entity-place">Orte</span> oder <span class="entity entity-org">
                                <a data-bs-toggle="modal" data-bs-target="#emt_institution_id__15">Institutionen</a>
                            </span> werden farblich hervorgehoben.</dd>
                        <dd class="ps-2">Ein Mouseklick auf eine solche Entität öffnet ein Fenster mit weiteren Informationen zu dieser Entität.</dd>

                        <dt>Abkürzungen</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>
                            <span tabindex="0" class="expan" data-bs-toggle="popover" data-bs-content="Abgekürzt: g">
                                gnaden
                            </span>
                        </dd>
                        <dd class="ps-2">Abkürzungen werden <span class="expan">mit Blauer Schrift</span> markiert und falls möglich aufgelöst. Die Abkürzung aus dem Original wird 
                            <span tabindex="0" class="expan" data-bs-toggle="popover">
                                <xsl:attribute name="data-bs-content">Das ist ein Popover
                                </xsl:attribute>
                                mittels Popover
                            </span>
                             angezeigt.</dd>

                        <dt>Softkorrekturen/Durchstreichungen</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>die ich mit <span class="seg-blackening">gehors</span>  trewester deuotion</dd>

                        <dt>Softkorrekturen/Ergänzungen</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>mihr zuehülf <span class="add">ruefen</span>, solliches zue </dd>

                        <dt>Datumsangaben</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>
                            <span tabindex="0" class="date" data-bs-toggle="popover" data-bs-content="1679-01-19">
                            19 jener 1679</span>
                        </dd>
                        <dd class="ps-2">Sofern ein genaues Datum von den Editorinnen eruiert werden konnte, so wird diese mittels Popover angezeigt, wenn man mit der Maus über die Datumsangabe fährt.</dd>

                        <dt>Ergänzungen durch Editorinnen</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>ganzergebenste trewgehorsa<span class="supplied">m</span>ste do<span class="supplied">c</span>hter
                        </dd>
                        <dt>Unklare Lesarten</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>hab ich nit 
                            <span tabindex="0" class="unclear" data-bs-toggle="popover" data-bs-content="unklare Abkürzung: wahrscheinlich fortschicken">
                                vortsch
                            </span>
                        </dd>
                        <dd class="ps-2">Bei unsicheren Lesarten wird ggf. eine mögliche Lesart via Popover angezeigt.</dd>
                        <dt>Chiffren</dt>
                        <dd class="ps-2">
                            <small>Beispiel: </small>insonderheit <span class="unclear-ciphered">weil Spanien in dieser sac</span>
                        </dd>
                        <dd class="ps-2">Siehe ausführlich zum Thema Chiffre: <a href="chiffre.html">Zur Chiffre der Kaiserin</a>
                        </dd>
                    </dl>
                    <p>Zu den <a href="richtlinien.html">Editionsrichtlinien</a>
                    </p>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn" data-bs-dismiss="modal">Schließen</button>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

</xsl:stylesheet>