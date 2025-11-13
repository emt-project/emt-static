<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:template match="tei:person" name="person_detail">
        <div class="row">
            <xsl:if test="./tei:figure">
                <div class="col d-flex justify-content-center">
                    <figure class="figure">
                        <img src="{concat('bio-pics/', .//tei:graphic[1]/@url)}" class="figure-img img-fluid rounded"></img>
                        <figcaption class="figure-caption">
                            Das <abbr title="{.//tei:caption/text()}">Bild</abbr> wurde automatisiert aus Wikidata übernommen.<xsl:element name="br"/>
                        </figcaption>
                    </figure>
                </div>
            </xsl:if>
            <div class="col">
                <table class="table entity-table">
                    <tbody>
                        <xsl:if test="./tei:birth/tei:date">
                            <tr>
                                <th>
                                    Geburtsdatum
                                </th>
                                <td>
                                    <xsl:value-of select="./tei:birth/tei:date"/>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="./tei:death/tei:date">
                            <tr>
                                <th>
                                    Sterbedatum
                                </th>
                                <td>
                                    <xsl:value-of select="./tei:death/tei:date"/>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test=".//tei:persName[@type='title']">
                            <tr>
                                <th>
                                    Titel
                                </th>
                                <td>
                                    <xsl:value-of select="string-join(.//tei:persName[@type='title']/tei:roleName, ', ')"/>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test=".//tei:persName[@type='function']">
                            <tr>
                                <th>
                                    Funktionsbezeichnungen
                                </th>
                                <td>
                                    <xsl:value-of select=".//tei:persName[@type='function']/tei:roleName/text()"/>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="./tei:idno[@type='NDB']/text()">
                            <tr>
                                <th>
                                    Deutsche Biographie
                                </th>
                                <td>
                                    <a href="{./tei:idno[@type='NDB']}" target="_blank">
                                        <xsl:value-of select="./tei:idno[@type='NDB']/text()"/>
                                    </a>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="./tei:idno[@type='GND']/text()">
                            <tr>
                                <th>
                                    GND ID
                                </th>
                                <td>
                                    <a href="{./tei:idno[@type='GND']}" target="_blank">
                                        <xsl:value-of select="tokenize(./tei:idno[@type='GND'], '/')[last()]"/>
                                    </a>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="./tei:idno[@type='URL']/text()">
                            <tr>
                                <th>
                                    weitere Links
                                </th>
                                <td>
                                    <a href="{./tei:idno[@type='URL']}" target="_blank">
                                        <xsl:value-of select="./tei:idno[@type='URL']/text()"/>
                                    </a>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="./tei:idno[@type='WIKIDATA']/text()">
                            <tr>
                                <th>
                                    Wikidata ID
                                </th>
                                <td>
                                    <a href="{./tei:idno[@type='WIKIDATA']}" target="_blank">
                                        <xsl:value-of select="tokenize(./tei:idno[@type='WIKIDATA'], '/')[last()]"/>
                                    </a>
                                </td>
                            </tr>
                        </xsl:if>
                        
                        <xsl:if test=".//tei:note[@type='mentions']">
                            <tr>
                                <th>
                                    Erwähnt in
                                </th>
                                <td>
                                    <ul>
                                        <xsl:for-each select=".//tei:note[@type='mentions']">
                                            <li>
                                                <a href="{replace(./@target, '.xml', '.html')}">
                                                    <xsl:value-of select="./text()"/>
                                                </a>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </td>
                            </tr>
                        </xsl:if>
                    </tbody>
                </table>
            </div>
        </div>
        
    </xsl:template>
</xsl:stylesheet>