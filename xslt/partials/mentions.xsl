<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:import href="./tabulator_dl_buttons.xsl"/>
    <xsl:template name="mentions-table">
    <div class="row mt-4">
                <div class="col">
                                <h2 class="fs-6">Erwähnt in:</h2>
                                <div class="text-center p-1" id="table-counter"></div>
                                    <table class="table" id="myTable">
                                        <thead>
                                            <tr>
                                                <th scope="col" tabulator-headerFilter="input" tabulator-visible="false" tabulator-download="false">itemid</th>
                                                <th scope="col" tabulator-headerFilter="input">Brief</th>
                                                <th scope="col" tabulator-headerFilter="input">Datum</th>
                                            </tr>
                                        </thead>
                                        <xsl:for-each select=".//tei:note[@type='mentions']">
                                            <tr>
                                                <td>
                                                    <xsl:value-of select="replace(./@target, '.xml', '.html')"/>
                                                </td>
                                                <td><xsl:value-of select="normalize-space(./text())"/></td>
                                                <td>
                                                    <xsl:choose>
                                                        <xsl:when test="starts-with(./@corresp, 'ERROR')">
                                                            <xsl:text>o.D.</xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                             <xsl:value-of select="./@corresp"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </table>
                                    <xsl:call-template name="tabulator_dl_buttons"/>
                </div>
</div>
    </xsl:template>
</xsl:stylesheet>