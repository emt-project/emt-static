<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    
    <xsl:import href="partials/biography-el.xsl"/>
    
    
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Ereignisse'"/>
        <html class="h-100" lang="de">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link rel="stylesheet" href="css/listevent.css" type="text/css"></link>
                <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"
                    integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A=="
                    crossorigin=""/>
                <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"
                    integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA=="
                    crossorigin=""></script>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="card-body text-center">
                        <ul style="margin-top:1em;padding-left:0;word-wrap:break-word;word-break:break-word;">
                            <xsl:for-each-group select="//tei:event" group-by="tokenize(./@notBefore, '-')[1]">
                                <xsl:sort select="current-grouping-key()" />
                                <li style="display:inline;list-style:none;margin-left:1em;">
                                    <a href="#{current-grouping-key()}" title="jump to date">
                                        <xsl:value-of select="current-grouping-key()"/>
                                    </a>
                                </li>
                            </xsl:for-each-group>
                        </ul>
                    </div>
                    
                    <div class="row">
                        <xsl:for-each-group select="//tei:event" group-by="tokenize(./@notBefore, '-')[1]">
                            <xsl:sort select="current-grouping-key()" />
                            <div class="timeline-wrapper" id="{current-grouping-key()}" style="padding-top:5em;">
                                <div class="text-center">                                            
                                    <h2 id="timeline-heading">
                                        <xsl:value-of select="current-grouping-key()"/>
                                        <a href="#page" title="jump to the top" style="color:#fff; font-size:12px;">
                                            <small>TOP</small>
                                        </a>                                            
                                    </h2>
                                </div>
                                <xsl:for-each select="current-group()">
                                    <div class="row timeline">
                                        
                                        <div class="col-md-5">    
                                            <xsl:call-template name="bio-el">
                                                <xsl:with-param name="location" select="'left'"/>
                                            </xsl:call-template>
                                        </div>
                                        <div class="col-md-2">
                                            <xsl:variable name="d" as="xs:date" select="./@notBefore"/>
                                            <xsl:variable name="date-formated" select="format-date($d, '[MNn] [D1o]', 'en', (), ())"/>
                                            <div class="timeline-circle text-center" data="{$date-formated}" />
                                            <!--<xsl:call-template name="bio-circle"/>-->
                                        </div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </xsl:for-each-group>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script type="text/javascript">
                    $('.timeline-circle').mouseover(function() {                                        
                    var date = $(this).attr('data');
                    $(this).html(date);                                        
                    });
                    $('.timeline-circle').mouseout(function() {
                    $(this).html("");
                    });
                </script>
                <script type="text/javascript" src="js/leaflet_bio.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>