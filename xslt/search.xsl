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
                            <div class="row">
                                <div class="col-md-4">
                                    <div id="stats-container"></div>
                                    <div id="searchbox"></div>
                                    <div id="search-fields-selector"></div>
                                    <fieldset class="row mb-3">
                                        <legend class="col-form-label col-sm-4 pt-0">Suchen in:</legend>
                                        <div class="form-check form-check-inline col-auto">
                                            <input class="search-attribute-checkbox m-2" type="checkbox" id="search-full-text" value="full_text" checked="checked"/>
                                            <label class="form-check-label" for="search-full-text">Volltext</label>
                                        </div>
                                        <div class="form-check form-check-inline col-auto">
                                            <input class="search-attribute-checkbox m-2" type="checkbox" id="search-keywords" value="keywords"/>
                                            <label class="form-check-label" for="search-keywords">Regesten</label>
                                        </div>
                                    </fieldset>
                                    <div id="current-refinements"></div>
                                    <div id="clear-refinements"></div>
                                    <!-- commented due to https://github.com/emt-project/emt-static/issues/71  -->
                                    <!-- 
                                    <h2 class="pt-2">Personen</h2>
                                    <div id="refinement-list-persons"></div>-->
                                    <h2 class="pt-2">Sender</h2>
                                    <div id="refinement-list-sender"></div>
                                    <h2 class="pt-2">Empfänger</h2>
                                    <div id="refinement-list-receiver"></div>
                                    <h2 class="pt-2">Orte</h2>
                                    <div id="refinement-list-places"></div>
                                    <h2 class="pt-2">Jahr</h2>
                                    <div id="range-input"></div>
                                </div>
                                <div class="col-md-8">
                                    <div id="hits"></div>
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