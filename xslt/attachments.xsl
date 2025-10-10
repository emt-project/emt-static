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
        <xsl:variable name="doc_title" select="'Beilagenverzeichnis'"/>

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
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="200">Dokument</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false">Titel</th>
                                    <th scope="col" tabulator-headerFilter="input">Datum</th>
                                    <th scope="col" tabulator-headerFilter="input">Ort</th>
                                    <th scope="col" tabulator-headerFilter="input">Absender</th>
                                    <th scope="col" tabulator-headerFilter="input">Empfänger</th>
                                    <th scope="col" tabulator-headerFilter="input">Typ</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false">Inhalt</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false">Sprache</th>

                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="collection('../data/editions?select=*.xml')//tei:div[@type='attachment' and not(@subtype='unmentionedSingleFile')]">
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="document-uri(/)"/>
                                    </xsl:variable>
                                    <xsl:variable name="doc_id">
                                        <xsl:value-of select="tokenize($full_path, '/')[last()]"/>
                                    </xsl:variable>
                                    <xsl:variable name="doc_title">
                                        <xsl:value-of select="ancestor::tei:TEI//tei:titleStmt/tei:title[@type='main']/text()"/>
                                    </xsl:variable>
                                    <xsl:variable name="attachment_number">
                                        <xsl:number level="any" from="tei:TEI" count="tei:div[@type='attachment']"/>
                                    </xsl:variable>

                                    <tr>
                                        <td>
                                            <xsl:value-of select="concat(replace($doc_id, '.xml', '.html'), '#attachment__', $attachment_number)" />
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="$doc_title != ''">
                                                    <xsl:value-of select="$doc_title"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="replace($doc_id, '.xml', '')"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="tei:head">
                                                    <xsl:value-of select="tei:head/text()"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>Beilage </xsl:text>
                                                    <xsl:value-of select="$attachment_number"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tei:ab/tei:date/@when-iso"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tei:ab/tei:placeName//text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(tei:ab/tei:persName[@type='sender']//text(), ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(tei:ab/tei:persName[@type='recipient']//text(), ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tei:ab/tei:note[@type='attachmentType']/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tei:ab/tei:note[@type='content']/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="tei:ab/tei:lang/text()"/>
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
                    <xsl:with-param name="counterTranslationKey" select="'attachments_counter_label'"/>
                </xsl:call-template>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>