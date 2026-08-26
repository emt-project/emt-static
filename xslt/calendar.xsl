<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:variable name="button-content-letters">
        <i class="bi bi-envelope fs-6"></i>
        <span>überlieferte Briefe</span>
    </xsl:variable>
    <xsl:variable name="button-content-mentioned-letters">
        <i class="bi bi-envelope-x fs-6"></i>
        <span>erwähnte Briefe</span>
    </xsl:variable>

    <xsl:template name="legend-item">
        <xsl:param name="dot-class" select="''"/>
        <xsl:param name="label" select="''"/>
        <xsl:param name="btn-group-label" select="concat($label, ' Filter')"/>
        <xsl:param name="kind-1"/>
        <xsl:param name="kind-1-suffix" select="'.html'"/>
        <xsl:param name="data-label-1"/>
        <xsl:param name="content-1"/>
        <xsl:param name="kind-2" select="''"/>
        <xsl:param name="data-label-2" select="''"/>
        <xsl:param name="content-2"/>
        <li>
            <xsl:if test="$dot-class != ''">
                <span class="dot {$dot-class}"></span>
            </xsl:if>
            <xsl:if test="$label != ''">
                <span class="legend-item">
                    <xsl:value-of select="$label"/>
                </span>
            </xsl:if>
            <div class="btn-group mt-2" role="group" aria-label="{$btn-group-label}">
                <button type="button" class="legend-toggle {$kind-1} w-100 active" data-bs-toggle="button" aria-pressed="true" data-kind="{$kind-1}{$kind-1-suffix}" data-label="{$data-label-1}" title="{$data-label-1} ausblenden">
                    <xsl:copy-of select="$content-1"/>
                </button>
                <xsl:if test="$kind-2 != ''">
                    <button type="button" class="legend-toggle {$kind-2} w-100 active" data-bs-toggle="button" aria-pressed="true" data-kind="{$kind-2}" data-label="{$data-label-2}" title="{$data-label-2} ausblenden">
                        <xsl:copy-of select="$content-2"/>
                    </button>
                </xsl:if>
            </div>
        </li>
    </xsl:template>

    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Briefkalender'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <link rel="stylesheet" href="vendor/calendar-component/calendar.css"/>
            <link rel="stylesheet" href="css/calendar.css"/>


            <body class="page">

                <xsl:call-template name="nav_bar"/>

                <main class="flex-shrink-0">
                    <div class="container">
                        <div class="d-flex justify-content-center align-items-end p-3">
                            <h1 class="text-center display-6 mb-0">Kalender</h1>
                            <a href="js-data/calendarData.json" class="btn btn-link" download="download">
                                <i class="bi bi-download ms-1" aria-hidden="true"></i>
                                <span class="visually-hidden">Kalenderdaten als JSON</span>
                            </a>
                        </div>
                        <acdh-ch-calendar>
                            <div class="calendar-menu">
                                <label class="p2 text-center fs-4">
                                    <span>Jahr</span>
                                </label>
                                <acdh-ch-calendar-year-picker/>
                                <label class="p2 text-center fs-4">Legende / Filter</label>
                                <acdh-ch-calendar-legend>
                                    <div class="legend-panel">
                                        <div class="legend-panel-header">Briefe nach Absender</div>
                                        <div class="btn-group w-100 mb-2" role="group" aria-label="Alle Absender">
                                            <button type="button" id="show-all-letters" class="btn btn-sm w-100">
                                                Alle anzeigen
                                            </button>
                                            <button type="button" id="hide-all-letters" class="btn btn-sm w-100">
                                                Alle ausblenden
                                            </button>
                                        </div>
                                        <ul id="sender-panel" class="list-unstyled d-flex flex-column gap-3">
                                            <xsl:call-template name="legend-item">
                                                <xsl:with-param name="dot-class" select="'emt_person_id__9'"/>
                                                <xsl:with-param name="label" select="'Eleonora Magdalena'"/>
                                                <xsl:with-param name="btn-group-label" select="'Eleonora Magdalena Filter'"/>
                                                <xsl:with-param name="kind-1" select="'emt_person_id__9'"/>
                                                <xsl:with-param name="data-label-1" select="'überlieferte Briefe von Eleonora Magdalena'"/>
                                                <xsl:with-param name="content-1" select="$button-content-letters"/>
                                                <xsl:with-param name="kind-2" select="'mentioned_letter_emt'"/>
                                                <xsl:with-param name="data-label-2" select="'erwähnte Briefe von Eleonora Magdalena'"/>
                                                <xsl:with-param name="content-2" select="$button-content-mentioned-letters"/>
                                            </xsl:call-template>
                                            <xsl:call-template name="legend-item">
                                                <xsl:with-param name="dot-class" select="'emt_person_id__18'"/>
                                                <xsl:with-param name="label" select="'Johann Wilhelm'"/>
                                                <xsl:with-param name="btn-group-label" select="'Johann Wilhelm Filter'"/>
                                                <xsl:with-param name="kind-1" select="'emt_person_id__18'"/>
                                                <xsl:with-param name="data-label-1" select="'überlieferte Briefe von Johann Wilhelm'"/>
                                                <xsl:with-param name="content-1" select="$button-content-letters"/>
                                                <xsl:with-param name="kind-2" select="'mentioned_letter_jw'"/>
                                                <xsl:with-param name="data-label-2" select="'erwähnte Briefe von Johann Wilhelm'"/>
                                                <xsl:with-param name="content-2" select="$button-content-mentioned-letters"/>
                                            </xsl:call-template>
                                            <xsl:call-template name="legend-item">
                                                <xsl:with-param name="dot-class" select="'emt_person_id__50'"/>
                                                <xsl:with-param name="label" select="'Philipp Wilhelm'"/>
                                                <xsl:with-param name="btn-group-label" select="'Philipp Wilhelm Filter'"/>
                                                <xsl:with-param name="kind-1" select="'emt_person_id__50'"/>
                                                <xsl:with-param name="data-label-1" select="'überlieferte Briefe von Philipp Wilhelm'"/>
                                                <xsl:with-param name="content-1" select="$button-content-letters"/>
                                                <xsl:with-param name="kind-2" select="'mentioned_letter_pw'"/>
                                                <xsl:with-param name="data-label-2" select="'erwähnte Briefe von Philipp Wilhelm'"/>
                                                <xsl:with-param name="content-2" select="$button-content-mentioned-letters"/>
                                            </xsl:call-template>
                                            <xsl:call-template name="legend-item">
                                                <xsl:with-param name="dot-class" select="'drittbriefe'"/>
                                                <xsl:with-param name="label" select="'Drittbriefe'"/>
                                                <xsl:with-param name="kind-1" select="'drittbriefe'"/>
                                                <xsl:with-param name="kind-1-suffix" select="''"/>
                                                <xsl:with-param name="data-label-1" select="'überlieferte Drittbriefe'"/>
                                                <xsl:with-param name="content-1" select="$button-content-letters"/>
                                            </xsl:call-template>
                                            <li>
                                                <span class="dot mehrere_briefe"></span>
                                                <span class="legend-item">Mehrere Briefe</span>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="legend-panel">
                                        <div class="legend-panel-header">
                                        Aufenthalte am kaiserlichen Hof
                                        </div>
                                        <ul class="list-unstyled d-flex flex-column gap-3">
                                            <xsl:call-template name="legend-item">
                                                <xsl:with-param name="kind-1" select="'visits'"/>
                                                <xsl:with-param name="kind-1-suffix" select="''"/>
                                                <xsl:with-param name="data-label-1" select="'Aufenthalte am kaiserlichen Hof mit sicherer Datierung)'"/>
                                                <xsl:with-param name="content-1">
                                                    <i class="bi bi-calendar-event fs-6"></i> sichere Datierung</xsl:with-param>
                                                <xsl:with-param name="kind-2" select="'visits_uncertain'"/>
                                                <xsl:with-param name="data-label-2" select="'Aufenthalte am kaiserlichen Hof mit unsicherer Datierung'"/>
                                                <xsl:with-param name="content-2">
                                                    <i class="bi bi-calendar-range fs-6"></i>unsichere Datierung</xsl:with-param>
                                            </xsl:call-template>
                                        </ul>
                                    </div>
                                </acdh-ch-calendar-legend>
                            </div>
                            <div class="calendar-container text-center">
                                <div class="d-flex justify-content-center align-items-end mb-3">
                                    <h2 class="fs-3 mb-0">
                                        Jahr <span id="year-title"></span>
                                    </h2>
                                    <button type="button" id="year-pdf-download-btn" class="btn btn-link pb-0" title="Korrespondenz des Jahres als PDF">
                                        <i class="bi bi-filetype-pdf me-1" aria-hidden="true"></i>
                                        <span>PDF</span>
                                    </button>
                                </div>
                                <acdh-ch-calendar-year data-variant="sparse"/>
                            </div>

                        </acdh-ch-calendar>

                        <div class="modal fade" id="dataModal" tabindex="-1" aria-labelledby="dataModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Schließen"/>
                                    </div>
                                    <div class="modal-body">
                                        <!-- Data content will be injected here by JavaScript -->
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn" data-bs-dismiss="modal">Schließen</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <xsl:call-template name="html_footer"/>
                <script type="module" src="js/calendar.js"/>
            </body>
        </html>
    </xsl:template>


</xsl:stylesheet>
