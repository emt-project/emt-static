<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/shared.xsl"/>
    
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="'Zeitleiste'"/>
        </xsl:variable>
        
        
        
        <html class="h-100" lang="de">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link title="timeline-styles" rel="stylesheet"
                    href="vendor/timeline3/css/timeline.css"></link>
                <script src="vendor/timeline3/js/timeline-min.js"></script>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container-fluid">                        
                        <div id="timeline-embed">
                            <div id="timeline"></div>
                        </div>
                        
                        
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="js/timeline.js"/>
            </body>
        </html>
    </xsl:template>
    
    
</xsl:stylesheet>
