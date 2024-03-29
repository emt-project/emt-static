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
            <xsl:value-of select='"Familiensache"'/>
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
                        <div class="col-2"/>
                        <div class="col-8">
                            <h1 class="display-1 text-center" data-i18n="index__h1"/>
                            <h2 class="display-4 text-center" data-i18n="index__h2"/>
                            <p class="text-center fs-4" data-i18n="index__teaser"/>
                            <div class="d-grid gap-2 col-6 mx-auto p-3">
                                <a href="projekt.html" type="button"
                                    class="btn btn-outline-secondary btn-lg button-custom">Über das
                                    Projekt</a>
                            </div>
                        </div>
                        <div class="col-2"/>
                    </div>

                    <!--  Briefverzeichnis   -->
                    <div class="container">
                        <hr class="hr-custom"/>
                        <div class="row">
                            <div class="col-md-7 p-3">
                                <img src="img/brief.jpg" class="img-fluid" alt="Bild eines Briefes"
                                />
                            </div>
                            <div class="col-md-5">
                                <div class="pt-5 pb-5 text-end">
                                    <h2 class="display-3">Briefverzeichnis</h2>
                                    <p class="fs-4">In die erschlossenen Korrespondenzen kann über
                                        eine tabellarische sowie eine kalendarische Ansicht
                                        eingestiegen werden.</p>
                                    <div>
                                        <a href="toc.html" type="button"
                                            class="btn btn-outline-secondary btn-lg button-custom"
                                            >Zum Verzeichnis</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--  Biographien   -->
                    <div class="container">
                        <hr class="hr-custom"/>
                        <div class="row">
                            <div class="col-md-5">
                                <div class="pt-5 pb-5">
                                    <h2 class="display-3">Biographien</h2>
                                    <p class="text-start fs-4">Biographische Skizzen zu <a
                                            href="philippwilhelm.html">Philipp Wilhelm</a>, <a
                                            href="eleonora.html">Eleonara</a> und <a
                                            href="johannwilhelm.html">Johann Wilhelm</a> von
                                        Pfalz-Neuburg.</p>
                                </div>
                            </div>
                            <div class="col-md-7 p-3">
                                <img src="img/biographien.jpg" class="img-fluid"
                                    alt="Symbolbild Biographien"/>
                            </div>
                        </div>
                    </div>

                    <!--  Blog   -->
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

                    <!-- Kontakt -->
                    <div class="container">
                        
                        <div class="row">
                            <div class="col">
                                <hr class="hr-custom"/>
                                <div class="pt-5 pb-5 text-center">
                                    <h2 class="display-3">Zitierempfehlung</h2>
                                    <p class="fs-4">Familiensache? Die Korrespondenz der Kaiserin Eleonora Magdalena (1655-1720). Bearbeitet von Katrin Keller, Ines Peper, Anna Spitzbart. Technische Umsetzung durch Peter Andorfer, Matthias Schlögl, Levente Kiraly. Wien 2024.</p>
                                </div>
                            </div>
                            <div class="col">
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
                        </div>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
