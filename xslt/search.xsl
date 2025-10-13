<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>

    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>

    <xsl:variable name="doc_title" select="'Volltextsuche'"/>

    <xsl:template match="/">
        <html class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container">
                        <h1 class="text-center display-5 p-3">
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div class="ais-InstantSearch">
                            <div class="row mb-3">
                                <div class="col">
                                    <div class="search-group mx-auto">
                                        <div class="d-flex gap-2 align-items-start">
                                            <div id="searchbox" class="flex-grow-1"></div>
                                            <label for="search-field-select" class="visually-hidden">Suchbereich auswählen</label>
                                            <select id="search-field-select" class="form-select w-auto">
                                                <option value="full_text,regest" selected="selected">Volltext + Regesten</option>
                                                <option value="full_text">Nur Volltext</option>
                                                <option value="regest">Nur Regesten</option>
                                            </select>
                                        </div>
                                        <div id="stats-container" class="mt-2"></div>
                                        <div id="search-fields-selector" class="mt-3 d-none"></div>
                                        <div id="current-refinements" class="mt-2"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-4">

                                    <div id="facets" class="d-grid gap-2">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <h2>Filter</h2>
                                            <div id="clear-refinements"></div>
                                        </div>
                                        <div id="refinement-list-sender"></div>
                                        <div id="refinement-list-receiver"></div>
                                        <div id="refinement-list-mentioned_persons"></div>
                                        <div id="refinement-list-sent_from"></div>
                                        <div id="refinement-list-mentioned_places"></div>
                                        <div id="refinement-list-orgs"></div>
                                        <div id="refinement-list-keywords"></div>
                                        <div id="range-input"></div>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="d-flex justify-content-end align-items-center gap-2 mb-3">
                                        <label for="ais-sort-by-select" class="me-2">Sortieren nach:</label>
                                        <div id="sort-by"></div>
                                    </div>
                                    <div id="hits" class="mb-3"></div>
                                    <div id="pagination"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <link rel="stylesheet" href="vendor/instantsearch.css/themes/algolia-min.css" />
                <script src="vendor/instantsearch/instantsearch.production.min.js"></script>
                <script src="vendor/typesense-instantsearch-adapter/typesense-instantsearch-adapter.min.js"></script>
                <script src="js/ts_index.js"></script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>