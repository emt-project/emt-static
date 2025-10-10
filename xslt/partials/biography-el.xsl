<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>
            <h1>Widget tei-facsimile.</h1>
            <p>Contact person: daniel.stoxreiter@oeaw.ac.at</p>
            <p>Applied with call-templates in html:body.</p>
            <p>The template "bio-el" adds a card for biography timeline.</p> 
            <p>Bootstrap is required.</p>
        </desc>    
    </doc>
    
    <xsl:template name="bio-el">
        <xsl:param name="img"/>
        <xsl:param name="location"/>          
        <xsl:choose>
            <xsl:when test="$location = 'left'">
                <div class="card-body">
                    <h6><xsl:value-of select=".//tei:eventName[1]/text()"/></h6>
                        <xsl:if test=".//tei:location[1]/tei:geo[1]/text()">
                            <xsl:variable name="lat" select="tokenize(.//tei:location[1]/tei:geo[1]/text(), ' ')[1]"/>
                            <xsl:variable name="long" select="tokenize(.//tei:location[1]/tei:geo[1]/text(), ' ')[2]"/>
                            <div class="leaflet-maps" lat="{$lat}" long="{$long}"></div>
                        </xsl:if>

                        
                        <xsl:choose>
                            <xsl:when test=".//tei:eventName[1]/tei:figure">
                                    <img class="event-image">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select=".//tei:graphic/@url"/>
                                        </xsl:attribute>
                                    </img>
                                    <figcaption><xsl:apply-templates select=".//tei:figure/tei:figDesc[1]"/></figcaption>
                                    <figcaption>(c) <xsl:apply-templates select=".//tei:figure/tei:figDesc[2]"/></figcaption>
                            </xsl:when>
                        </xsl:choose>    
                        <ul>
                            <xsl:for-each select=".//tei:placeName/*">
                                <li><xsl:apply-templates/></li>
                            </xsl:for-each>
                        </ul>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div class="card timeline-panel-{$location}">   
                    <div class="card-body">
                        <xsl:choose>
                            <xsl:when test="./tei:label">
                                <a title="open document" href="{replace(@xml:id, '.xml', '.html')}">
                                    <span><xsl:value-of select="substring-before(translate(translate(./tei:label, '[', ''), ']', ''), ' 19')"/></span>
                                </a>
                            </xsl:when>
                            <xsl:when test="./tei:eventName">
                                <h6><xsl:value-of select="./tei:eventName/text()"/></h6>
                                <span><xsl:value-of select="./tei:desc/text()"/></span>
                                <!--<table class="table">
                                    <tbody>
                                        <xsl:for-each select="./tei:desc/tei:location/tei:address/tei:placeName/*">
                                            <tr>
                                                <th class="capitalize"
                                                    style="border:none;border-right: 1px solid #f1f1f1;width:25%;padding:.2em;">
                                                    <xsl:value-of select="name()"/>
                                                </th>
                                                <td style="border:none;padding:.2em;.5em;">
                                                    <xsl:apply-templates/>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                    
                                </table>-->
                                
                                <xsl:if test="./tei:desc/tei:idno[@type='geonames']">
                                    <xsl:element name="br"/>
                                    <xsl:element name="br"/>
                                    <span style="font-weight: bold;">Geonames ID: </span>
                                    <a target="_blank" href="{./tei:desc/tei:idno[@type='geonames']}">
                                        <xsl:value-of select="tokenize(./tei:desc/tei:idno[@type='geonames'], '/')[last()]"/>
                                    </a>
                                </xsl:if>
                                
                                <xsl:if test="./tei:desc/tei:location/tei:geo/text()">
                                    <xsl:variable name="lat" select="tokenize(./tei:desc/tei:location/tei:geo, ' ')[1]"/>
                                    <xsl:variable name="long" select="tokenize(./tei:desc/tei:location/tei:geo, ' ')[2]"/>
                                    <div class="leaflet-maps" lat="{$lat}" long="{$long}"></div>
                                </xsl:if>
                            </xsl:when>                            
                        </xsl:choose>                        
                    </div>
                </div>
            </xsl:otherwise>
        </xsl:choose>                                                                             
        
    </xsl:template>
</xsl:stylesheet>