<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:wfw="http://wellformedweb.org/CommentAPI/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:atom="http://www.w3.org/2005/Atom" xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
    xmlns:slash="http://purl.org/rss/1.0/modules/slash/" version="3.0"
    exclude-result-prefixes="xsl tei xs local">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>


    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"EMT"'/>
        </xsl:variable>


        <html class="h-100">

            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <div id="carouselExampleCaptions" class="carousel slide">

                    <div class="carousel-inner">
                        <div class="carousel-item active">
                            <img src="img/banner.jpg" class="d-block w-100" alt="..."/>
                        </div>
                    </div>
                </div>
                <main class="flex-shrink-0">


                    <div class="row p-3">
                        <div class="col-3"/>
                        <div class="col-6">
                            <p class="text-center fs-4">Zwischen 1677 und 1716 gingen eine Unzahl
                                von Briefen hin und her zwischen Wien, Düsseldorf und Heidelberg:
                                Kaiserin Eleonora Magdalena korrespondierte mit Vater bzw. Bruder,
                                den Kurfürsten von der Pfalz. Erstmals wird hier die umfangreiche
                                Korrespondenz im Volltext zugänglich gemacht. </p>
                            <div class="d-grid gap-2 col-5 mx-auto p-3">
                                <a href="projekt.html" type="button"
                                    class="btn btn-outline-secondary btn-lg button-custom">Über das
                                    Projekt</a>
                            </div>
                        </div>
                        <div class="col-3"/>
                    </div>

                    <!--  Briefverzeichnis   -->
                    <div>
                        <div class="container">
                            <hr class="hr-custom"/>
                        </div>
                        <div class="image-container2">
                            <img src="img/brief.jpg" class="img-fluid" alt="Symbolbild Brief"/>
                            <div class="image-text">
                                <h2 class="display-3"> Briefverzeichnis </h2>
                                <p class="text-start fs-4 col-6">In die erschlossenen
                                    Korrespondenzen kann über eine tabellarische sowie eine
                                    kalendarische Ansicht eingestiegen werden.</p>
                                <div class="d-grid gap-2 col-3">
                                    <a href="toc.html" type="button"
                                        class="btn btn-outline-secondary btn-lg button-custom">Zum
                                        Verzeichnis</a>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--  Biographien   -->

                    <div class="container">
                        <hr class="hr-custom"/>
                    </div>
                    <div class="row bio">
                        <div class="col-2"/>
                        <div class="col-8">
                            <div class="image-container-bio">
                                <img src="img/biographien.jpg" class="img-fluid"
                                    alt="Symbolbild Brief"/>
                                <div class="image-text-bio">
                                    <h2 class="display-3">Biographien</h2>
                                </div>
                                <div class="image-bio-buttons">
                                    <div class="row justify-content-evenly">
                                        <div class="col-md-4">
                                            <a href="philippwilhelm.html" type="button"
                                                class="btn btn-outline-secondary btn-lg button-bio"
                                                >PHILIPP WILHELM VON PFALZ-NEUBURG </a>
                                        </div>
                                        <div class="col-md-4">
                                            <a href="eleonora.html" type="button"
                                                class="btn btn-outline-secondary btn-lg button-bio"
                                                >Eleonora Magdalena Theresia von Pfalz-Neuburg </a>
                                        </div>
                                        <div class="col-md-4">
                                            <a href="johannwilhelm.html" type="button"
                                                class="btn btn-outline-secondary btn-lg button-bio"
                                                >JOHANN WILHELM VON PFALZ-NEUBURG </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-2"/>
                    </div>
                    
                    <div class="container">
                        <hr class="hr-custom"/>
                        <div class="row">
                            <div class="col-md-7 p-3">
                                <img src="img/blog.jpg" class="img-fluid" alt="Symbolbild Blog"/>
                            </div>
                            <div class="col-md-5">
                                <div class="pt-5 pb-5 text-end">
                                    <h2 class="display-3">Blog</h2>
                                    <p class="fs-4">Wenn man heute von Kaiserinnen spricht, so
                                        denken die meisten, gerade in Wien, eigentlich nur an zwei
                                        Frauen: Maria Theresia und Elisabeth, genannt Sissi. Dabei
                                        gibt es seit dem Mittelalter eine lange Reihe von Frauen,
                                        die diesen Titel trugen und denen damit im Rahmen des
                                        Heiligen Römischen Reiches herrschaftliche Befugnisse,
                                        zeremonieller Rang und symbolische Bedeutung zukamen. Mit
                                        diesen Fürstinnen der Frühen Neuzeit hat sich die Forschung
                                        bislang jedoch kaum beschäftigt. Der Blog liefert Einblicke
                                        in unser derzeit laufendes Forschungsprojekt und führt die
                                        politische und repräsentative Rolle dieser Frauen vor
                                        Augen...</p>
                                    <div>
                                        <a href="https://kaiserin.hypotheses.org/" type="button"
                                            class="btn btn-outline-secondary btn-lg button-custom"
                                            >Zum Blog</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--  Kontakt -->
                    <div class="container">
                        <hr class="hr-custom"/>
                        <div class="pt-5 pb-5 text-center">
                            <h2 class="display-3">Kontakt</h2>
                            <p class="fs-4">Das Projekt “Familiensache. Dynastische
                                Handlungsspielräume in der Korrespondenz von Kaiserin Eleonora
                                Magdalena von Pfalz-Neuburg (1655-1720)” wird am Institut für die
                                Erforschung der Habsburgermonarchie und des Balkanraumes der
                                Österreichischen Akademie der Wissenschaften durchgeführt und durch
                                den FWF gefördert.</p>
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
