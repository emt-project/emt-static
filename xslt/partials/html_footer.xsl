<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="html_footer">
        <footer class="py-3">

            <div class="container text-center">
                <div class="pb-2">
                    <span class="fs-3">Kontakt</span>
                </div>
                <div class="row justify-content-md-center">
                    <div class="col col-lg-4">
                        <div>
                            <a href="https://www.oeaw.ac.at/ihb/home">
                                <img class="footerlogo" src="./logos/ihb-logo-en-text.png" alt="IHB Logo"/>
                            </a>
                        </div>
                        <div class="text-center p-4">
                            Institute for Habsburg and Balkan Studies
                            <xsl:element name="br"/>
                            <a href="mailto:katrin.keller@oeaw.ac.at">katrin.keller@oeaw.ac.at</a>
                        </div>
                    </div>
                    <div class="col col-lg-4">
                        <div>
                            <a href="https://www.oeaw.ac.at/acdh/acdh-ch-home">
                                <img class="footerlogo" src="./logos/acdh_logo_with_text.png" alt="ACDH-CH Logo"/>
                            </a>
                        </div>
                        <div class="text-center p-4">
                            Austrian Centre for Digital Humanities
                            <xsl:element name="br"/>
                            <a href="mailto:acdh-helpdesk@oeaw.ac.at">acdh-helpdesk@oeaw.ac.at</a>
                        </div>
                    </div>

                </div>
                <div class="pb-2 pt-2">
                    <span class="fs-3">Förderinstitutionen</span>
                </div>
                <div class="row justify-content-md-center">

                    <div class="col">
                        <img src="./logos/fwf-logo-transparent.png" alt="FWF Logo" class="footerlogo"/>
                        <div class="text-center p-3">
                            Gefördert aus Mitteln Wissenschaftsfonds FWF <a href="https://www.fwf.ac.at/forschungsradar/10.55776/P34651" class="dse-dotted">10.55776/P34651</a> und <a href="https://www.fwf.ac.at/forschungsradar/10.55776/PAT3146724" class="dse-dotted">10.55776/PAT3146724</a>
                        </div>
                    </div>


                </div>
            </div>



            <div class="text-center">
                <a href="{$github_url}">
                    <i aria-hidden="true" class="bi bi-github fs-2"></i>
                    <span class="visually-hidden">GitHub repo</span>
                </a>
            </div>
        </footer>
        <script src="vendor/jquery/jquery-3.6.3.min.js"></script>
        <script src="vendor/bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js"></script>
        <script src="js/i18n.js"></script>

    </xsl:template>
</xsl:stylesheet>