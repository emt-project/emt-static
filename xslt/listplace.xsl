<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    

    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="partials/place.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <html  class="h-100">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link rel="stylesheet" href="vendor/leaflet/leaflet.css"   />
                <script src="vendor/leaflet/leaflet.js"></script>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container">
                        <h1 class="text-center display-5 p-3"><xsl:value-of select="$doc_title"/></h1>
                        <div class="text-center p-1" id="table-counter"></div>
                        <div id="map"/>
                        <table class="table" id="placesTable">
                            <thead>
                                <tr>
                                    <th scope="col" >Ortsname</th>
                                    <th scope="col" >Absendeort</th>
                                    <th scope="col" >Erwähnungen</th>
                                    <th scope="col" >lat</th>
                                    <th scope="col" >lng</th>
                                    <th scope="col" >ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:place">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <xsl:value-of select=".//tei:placeName[1]/text()"/>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test=".//tei:state[@type='sender']">true</xsl:when>
                                                <xsl:otherwise>false</xsl:otherwise>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:note[@type='mentions'])"/>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="./tei:location/tei:geo">
                                                    <xsl:value-of select="tokenize(./tei:location/tei:geo/text(), ' ')[1]"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="./tei:location/tei:geo">
                                                    <xsl:value-of select="tokenize(./tei:location/tei:geo/text(), ' ')[last()]"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat($id, '.html')"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="$id"/>
                                            </a>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
<!--                        <xsl:call-template name="tabulator_dl_buttons">/>-->
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script type="text/javascript" src="vendor/tabulator-tables/js/tabulator.min.js"></script>
                <script src="js/map_table_cfg.js"/>
                <script src="js/make_map_and_table.js"/>
                
                <script>
                    build_map_and_table(map_cfg, table_cfg, wms_cfg=null, tms_cfg=tms_cfg);
                </script>
                <!--<xsl:call-template name="tabulator_js"/>-->
            </body>
        </html>
        <xsl:for-each select=".//tei:place[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:placeName[1]//text()))"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html  class="h-100">
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
                                
                                <xsl:if test="./tei:location/tei:geo">
                                    <div class="row">
                                        <div class="col-md-4"><div id="map_detail"/></div>
                                        <div class="col-md-8">
                                            <xsl:call-template name="place_detail"/>
                                        </div>
                                    </div>
                                
                                </xsl:if>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                        <xsl:if test="./tei:location/tei:geo">
                            <link rel="stylesheet" href="vendor/leaflet/leaflet.css"/>
                            <script src="vendor/leaflet/leaflet.js"></script>
                            <script>
                                var baseLayer = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                maxZoom: 19,
                                attribution: '&amp;copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                                });
                                var tmsLayer = L.tileLayer('https://emt-project.github.io/mapserver/map_01/{z}/{x}/{y}.png', {tms: 1, opacity: 0.8, minZoom: 2, maxZoom: 12, attribution: "Austrian National Library (ÖNB)"})
                                var baseMaps = {
                                "OpenStreetMap": baseLayer,
                                "Historische Karte": tmsLayer
                                };
                                
                                var lat = <xsl:value-of select="tokenize(.//tei:geo[1]/text(), ' ')[1]"/>;
                                var long = <xsl:value-of select="tokenize(.//tei:geo[1]/text(), ' ')[last()]"/>;
                                $("#map_detail").css("height", "500px");
                                var map = L.map('map_detail', {layers: [baseLayer, tmsLayer]}).setView([Number(lat), Number(long)], 7);
                                
                                
                                var marker = L.marker([Number(lat), Number(long)]).addTo(map);
                                var layerControl = L.control.layers(baseMaps).addTo(map);
                            </script>
                        </xsl:if>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>