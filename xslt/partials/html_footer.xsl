<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="footer mt-auto py-3">
            
            <div class="container">
                <div class="d-flex justify-content-center pb-4">
                    
                        <a href="https://www.oeaw.ac.at/" target="_blank" rel="noopener" aria-label="OEAW">
                            <img src="logos/oeaw-logo-transparent.png" alt="OEAW" title="Austrian Academy of Sciences"/>
                        </a>
                    
                </div>
                
                <div class="row justify-content-between pb-4">
                    <div class="col-sm-4">
                        <a href="https://www.oeaw.ac.at/ihb/" target="_blank" rel="noopener" aria-label="IHB">
                            <img src="logos/ihb-logo-en-text.png" alt="IHB" title="Institut for Habsburg and Balkan Studies"/>
                        </a>
                    </div>
                    <div class="col-sm-4">
                        Institute for Habsburg and Balkan Studies<br/>
                        Dominikanerbastei 16<br/>
                        1010 Vienna (Austria)<br/>
                    </div>
                </div>
                
                <div class="row justify-content-between pb-4">
                    <div class="col-sm-4">
                        <a href="https://www.oeaw.ac.at/acdh/" target="_blank" rel="noopener" aria-label="ACDH">
                            <img src="logos/acdh_logo_with_text.svg" alt="ACDH" title="Austrian Centre for Digital Humanities and Cultural Heritage (ACDH-CH) of the Austrian Academy of Sciences"/>
                        </a>
                    </div>
                    <div class="col-sm-4">
                        Austrian Centre for Digital Humanities and Cultural Heritage<br/>
                        Bäckerstraße 13<br/>
                        1010 Vienna<br/>
                    </div>
                </div>
                
                <div class="d-flex justify-content-center">
                        <a href="https://www.fwf.ac.at/" target="_blank" rel="noopener" aria-label="FWF">
                            <img src="logos/fwf-logo-transparent.png" alt="FWF" title="FWF Science-Fond" style="max-width: 300px"/>
                        </a>
                </div>
                
            </div>
            <div class="text-center pt-4">
                <a href="{$github_url}"><i class="fs-1 bi bi-github" aria-hidden="true"></i><span class="visually-hidden">GitHub Link</span></a>
            </div>
        </footer>
        <script src="vendor/jquery/jquery-3.6.3.min.js"></script>
        <script src="vendor/bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/i18n.js"></script>
        
    </xsl:template>
</xsl:stylesheet>