<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Briefverzeichnis'"/>



        <html class="h-100">

            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>

            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container">
                        <h1 class="text-center display-5 p-3">
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div class="text-center p-1" id="table-counter"></div>
                        <table class="table" id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" width="20" tabulator-formatter="html" tabulator-headerSort="false" tabulator-download="false" tabulator-visible="false">itemId</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="350">Sender</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="200">Empfänger</th>
                                    <th scope="col" tabulator-headerFilter="input">Datum</th>
                                    <th scope="col" tabulator-headerFilter="input">Erschließungsstand</th>
                                    <th scope="col" tabulator-headerFilter="input">Ort</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false">Dateinname</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="collection('../data/editions?select=*.xml')//tei:TEI">
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="document-uri(/)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')" />
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:correspAction[@type='sent']/tei:persName/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:correspAction[@type='received']/tei:persName/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="data(.//tei:correspAction[@type='sent']//tei:date/@when-iso)[1]"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="data(.//tei:revisionDesc/@n)"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:correspAction[@type='sent']/tei:placeName/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tokenize($full_path, '/')[last()]"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js">
                    <xsl:with-param name="addHeaderMenu" select="'true'"/>
                    <xsl:with-param name="counterTranslationKey" select="'toc_counter_label'"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>