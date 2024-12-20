<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Briefkalender'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <link rel="stylesheet"
                href="vendor/calendar-component/calendar.css"/>
            <link rel="stylesheet" href="css/calendar.css"/>


            <body class="page">

                <xsl:call-template name="nav_bar"/>

                <div class="container">

                    <h1 class="text-center display-5 p-3"> Kalender</h1>
                    <a style="padding-left:5px;" href="js-data/calendarData.js">
                        <i class="fas fa-download" title="Data"/>
                    </a>

                    <acdh-ch-calendar>
                        <div class="calendar-menu">
                            <label class="p2 text-center fs-2">
                                <span>Jahr</span>
                            </label>
                            <acdh-ch-calendar-year-picker/>
                            <span class="p2 text-center fs-2">Legende</span>
                            <acdh-ch-calendar-legend>
                                <ul class="list-unstyled">
                                    <li>
                                        <span class="dot emt_person_id__9"></span>
                                        <span class="legend-item">Eleonora Magdalena von Pfalz-Neuburg</span>
                                    </li>
                                    <li>
                                        <span class="dot emt_person_id__18"></span>
                                        <span class="legend-item">Johann Wilhelm von Pfalz-Neuburg</span>
                                    </li>
                                    <li>
                                        <span class="dot emt_person_id__50"></span>
                                        <span class="legend-item">Philipp Wilhelm von Pfalz-Neuburg</span>
                                    </li>
                                    <li>
                                        <span class="dot emt_person_id__50"></span>
                                        <span class="legend-item">Philipp Wilhelm von Pfalz-Neuburg</span>
                                    </li>
                                    <li><span class="dot menioned_letter_pw"></span>
                                        <span class="legend-item">Philipp Wilhelm von Pfalz-Neuburg (erwähnter Brief)</span>
                                    </li>
                                    <li>
                                        <span class="dot Brief_erschlossen"></span>
                                        <span class="legend-item">In der Korrespondenz erwähnter Brief</span>
                                    </li>
                                    <li>
                                        <span class="dot mehrere_briefe"></span>
                                        <span class="legend-item">Mehrere Briefe unterschiedlicher AbsenderInnen</span>
                                    </li>
                                    <li>
                                        <span class="dot emt_person_id__14"></span>
                                        <span class="legend-item">Franziska Sibylla von Baden-Baden, geb. Sachsen-Lauenburg</span>
                                    </li>
                                </ul>
                            </acdh-ch-calendar-legend>
                        </div>

                        <acdh-ch-calendar-year data-variant="sparse"/>
                    </acdh-ch-calendar>

                    <div class="modal fade" id="dataModal" tabindex="-1"
                        aria-labelledby="dataModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Schließen"/>
                                </div>
                                <div class="modal-body">
                                    <!-- Data content will be injected here by JavaScript -->
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Schließen</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <xsl:call-template name="html_footer"/>
                <script type="module" src="js/calendar.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
