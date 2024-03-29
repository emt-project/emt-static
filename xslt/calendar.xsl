<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Briefkalender'"/>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
            </xsl:call-template>
            <body class="page">
                <script src="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.js"></script>
                <script src="https://unpkg.com/js-year-calendar@latest/locales/js-year-calendar.de.js"></script>
                <link rel="stylesheet" type="text/css" href="https://unpkg.com/js-year-calendar@latest/dist/js-year-calendar.min.css" />
                <script src="js-data/calendarData.js"></script>
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    
                    <div class="container-fluid">                        
                        
                        <h1 class="text-center display-3 p-3">
                                    Kalender</h1>
                                <a style="padding-left:5px;" href="js-data/calendarData.js">
                                    <i class="fas fa-download" title="Data"/>
                                </a>
                           
                            <div class="containingloader">
                                <div class="row">
                                    <div class="col-sm-2 yearscol">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <p style="text-align:center;font-weight:bold;margin-bottom:0;">Jahr</p>
                                            </div>
                                        </div>
                                        <div class="row justify-content-md-center" id="years-table">
                                            
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <p style="text-align:center;font-weight:bold;margin-top:1rem;margin-bottom:0;" data-i18n="calendar__legendtitle"></p>
                                            </div>
                                        </div>
                                     
                                            <div class="row d-flex flex-row flex-nowrap align-items-baseline mt-2" id="calendar-legend">
                                                <span style="position: relative; height: 0.64rem; width: 0.64rem; background-color: #A63437; border-radius: 50%; margin-right: 1rem;"></span>
                                                <span style="flex: 1;" data-i18n="calendar__legendextant"></span>
                                            </div>
                                            <div class="row d-flex flex-row flex-nowrap  align-items-baseline" id="calendar-legend">
                                                <span style="display: inline-block; position: relative; height: 0.64rem; width: 0.64rem; background-color: #BADA55; border-radius: 50%; margin-right: 1rem;"></span>
                                                <span style="flex: 1;" data-i18n="calendar__legendrefd"></span>
                                            </div>
                                        
                                    </div>
                                    <div class="col-sm-10">
                                        <div id="calendar"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                </div>
                    <script type="text/javascript" src="./js/calendar.js" charset="UTF-8"/>
                    <div id="loadModal"/>
                    <xsl:call-template name="html_footer"/>
               
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>