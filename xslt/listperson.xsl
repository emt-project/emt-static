<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/person.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
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
                                    <th scope="col" width="20" tabulator-formatter="html" tabulator-headerSort="false" tabulator-visible="false" tabulator-download="false">itemid</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-minWidth="350">Name</th>
                                    <th scope="col" tabulator-headerFilter="input">Titel</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false">Funktionsbezeichnungen</th>
                                    <th scope="col" tabulator-headerFilter="input">Lebensdaten</th>
                                    <th scope="col" tabulator-headerFilter="input">Erwähnungen</th>
                                    <th scope="col" tabulator-headerFilter="input">Sender / Empfänger</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:person[@xml:id]">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="concat($id, '.html')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:persName[1]/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(.//tei:persName[@type='title']/tei:roleName, ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:persName[@type='function']/tei:roleName/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select=".//tei:birth[1]/tei:date[1]/text()"/>
 -                                            <xsl:value-of select=".//tei:death[1]/tei:date[1]/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:note[@type='mentions'])"/>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test=".//tei:state[@type='sender'] and .//tei:state[@type='receiver']">
                                                    <xsl:text>Sender, Empfänger</xsl:text>
                                                </xsl:when>
                                                <xsl:when test=".//tei:state[@type='sender']">
                                                    <xsl:text>Sender</xsl:text>
                                                </xsl:when>
                                                <xsl:when test=".//tei:state[@type='receiver']">
                                                    <xsl:text>Empfänger</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$id"/>
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
                    <xsl:with-param name="counterTranslationKey" select="'listperson_counter_label'"/>
                </xsl:call-template>
            </body>
        </html>


        <xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="./tei:persName[1]/text()"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>

                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main>
                            <div class="container">
                                <h1 class="display-5 text-center">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="person_detail"/>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                        <xsl:call-template name="tabulator_js"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>