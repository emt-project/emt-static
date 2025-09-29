<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">

    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/osd-container.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:import href="./partials/html_title_navigation.xsl"/>


    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>


    <xsl:template match="/">


        <html class="h-100">

            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <script src="vendor/openseadragon-bin-4.1.1/openseadragon.min.js"/>
                <script src="js/osd_single.js"></script>
                <script src="js/popover.js"></script>
                <script src="js/info-scroll.js"></script>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container-xl">
                        <xsl:call-template name="header-nav">
                            <xsl:with-param name="doc_title" select="$doc_title"/>
                        </xsl:call-template>

                        <div class="regest">
                            <h4>
                                <xsl:for-each select=".//tei:ab[@type='abstract-terms']/tei:term">
                                    <span class="badge rounded-pill text-bg-secondary">
                                        <xsl:value-of select="./text()"/>
                                    </span>
                                </xsl:for-each>
                            </h4>
                            <div class="regest-text">
                                <xsl:apply-templates select=".//tei:abstract[@n='regest']"></xsl:apply-templates>
                            </div>
                        </div>
                        <xsl:for-each select=".//tei:div[@type='page']">


                            <!-- If this is the first page of an attachment, output the attachment header first -->
                            <xsl:if test="parent::tei:div[@type='attachment'] and not(preceding-sibling::tei:div[@type='page'])">
                                <div class="row attachment-header">
                                    <div class="col-md-12">
                                        <xsl:apply-templates select="../tei:head"/>
                                        <xsl:if test="../tei:ab">
                                            <div class="attachment-metadata">
                                                <xsl:apply-templates select="../tei:ab"/>
                                            </div>
                                        </xsl:if>
                                    </div>
                                </div>
                            </xsl:if>

                            <xsl:variable name="pbFacs">
                                <xsl:value-of select="replace(data(./tei:pb/@xml:id), '.jpg', '')" />
                            </xsl:variable>
                            <xsl:variable name="pbFolio" as="node()">
                                <xsl:value-of select="data(./tei:pb/@n)" />
                            </xsl:variable>
                            <xsl:variable name="openSeadragonId">
                                <xsl:value-of select="concat('os-id-', substring((tokenize(./tei:pb/@facs, ' ')[1])[1], 7))"/>
                            </xsl:variable>
                            <xsl:variable name="rotation">
                                <xsl:value-of select="data(./tei:pb/@rend)"/>
                            </xsl:variable>
                            <xsl:variable name="facs-url" select="data((./tei:pb/@source)[1])"/>
                            <!--commented out due to https://github.com/emt-project/emt-static/issues/152 , will switch back to ARCHE after another archiving round at the end of the project-->
                            <!-- <xsl:variable name="facs-url" select="concat(tokenize(data((./tei:pb/@facs)[1]), ' ')[2], '?format=iiif')"/> -->
                            <div class="row">
                                <div class="col-md-12 pe-xl-0 pe-5">
                                    <div class="float-end">
                                        <h5>
                                            <xsl:value-of select="$pbFolio"/>
                                        </h5>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div id="{$openSeadragonId}">
                                        <img id="{$openSeadragonId}-img" src="{normalize-space($facs-url)}" onload="loadImage('{$openSeadragonId}', '{$rotation}')"></img>
                                        <!-- cosy spot for OSD viewer  -->
                                    </div>
                                </div>
                                <div class="col-md-6 pe-xl-0 pe-5 editionstext">
                                    <xsl:apply-templates/>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <hr />
                                </div>
                            </div>
                        </xsl:for-each>


                        <p style="text-align:center;">
                            <xsl:variable name="footnote-notes" select=".//tei:note[not(./tei:p) and not(ancestor::tei:div[@type='attachment']/tei:ab)]"/>

                            <xsl:for-each select="$footnote-notes">
                                <xsl:variable name="note-number" select="position()"/>

                                <div class="footnote" id="{local:makeId(.)}">
                                    <a name="fn{$note-number}" href="#fna_{$note-number}">
                                        <span class="footnote-number">
                                            <xsl:value-of select="$note-number"/>
                                        </span>
                                    </a>
                                    <span class="footnote-content">
                                        <xsl:apply-templates/>
                                    </span>
                                </div>
                            </xsl:for-each>
                        </p>

                    </div>
                    <div class="back p-3">
                        <xsl:for-each select="//tei:back">
                            <xsl:apply-templates/>
                        </xsl:for-each>
                        <xsl:for-each select="//tei:rs/@ref[contains(., ' ')]">
                            <xsl:variable name="rsCnt">
                                <xsl:number level="any" count="//tei:rs[contains(@ref, ' ')]"/>
                            </xsl:variable>
                            <xsl:variable name="back" select="root()//tei:back" as="node()"/>
                            <xsl:variable name="modalId" select="concat(replace(string-join(tokenize(., ' #')), '#', ''), '--', $rsCnt)"/>
                            <xsl:variable name="modalHead">
                                <xsl:value-of select="normalize-space(string-join(..//text()[not(parent::tei:abbr)]))"/>
                            </xsl:variable>

                            <div class="modal fade" id="{$modalId}" data-bs-keyboard="false" tabindex="-1" aria-labelledby="{$modalHead}" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="staticBackdropLabel">
                                                <xsl:value-of select="$modalHead"/>
                                            </h1>
                                        </div>
                                        <div class="modal-body">
                                            <ul>
                                                <xsl:for-each select="tokenize(., ' ')">
                                                    <xsl:variable name="entRef" select="replace(., '#', '')"/>
                                                    <xsl:variable name="entNode" select="$back//*[@xml:id=$entRef]"/>
                                                    <xsl:variable name="entLabel" select="$entNode/*[1]/text()"/>
                                                    <li>
                                                        <a href="{$entRef||'.html'}">
                                                            <xsl:value-of select="$entLabel"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </xsl:for-each>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>



            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:p">
        <p id="{local:makeId(.)}" data-id="{@facs}">
            <xsl:for-each-group select="node()[normalize-space(.) or name(.)]" group-starting-with="self::tei:lb">
                <span class="transcript-line">
                    <span class="transcript-line-number">
                        <xsl:apply-templates select="current-group()[self::tei:lb]"/>
                    </span>
                    <span class="transcript-line-contents">
                        <xsl:for-each select="current-group()[not(name()='lb')]">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </span>
                </span>
            </xsl:for-each-group>
        </p>
    </xsl:template>
    <xsl:template match="tei:div">
        <div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:head">
        <h2 id="{local:makeId(.)}" class="text-center fs-5 text-decoration-underline my-4">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <xsl:template match="tei:ab">
        <xsl:for-each select="*">
            <p class="attachment-metadata-item">
                <xsl:apply-templates select="."/>
            </p>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:note[@type='attachmentType']">
        <span class="badge rounded-pill text-bg-secondary">
            <xsl:value-of select="./text()"/>
        </span>

    </xsl:template>
    <xsl:template match="tei:note[@type='content']">
        <div class="regest-text">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:ref[@target]">
        <xsl:variable name="href_value">
            <xsl:choose>
                <xsl:when test="starts-with(@target, 'http')">
                    <xsl:value-of select="data(@target)"/>
                </xsl:when>
                <xsl:when test="ends-with(@target, '.xml')">
                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                </xsl:when>
                <xsl:when test="ends-with(@target, '.jpg')">
                    <xsl:value-of select="replace(@target, '.jpg', '.html')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="data(@target)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a href="{replace($href_value, '#', '')}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:variable name="idx" select="format-number(number(replace(@n, 'N', '')), '#')"/>
        <xsl:if test="not(ancestor::tei:note[@type='footnote'])">
            <xsl:if test="ancestor::tei:p">
                <a>
                    <xsl:variable name="para" as="xs:int">
                        <xsl:number level="any" from="tei:body" count="tei:p"/>
                    </xsl:variable>
                    <xsl:variable name="lines" as="xs:int">
                        <xsl:number level="any" from="tei:body"/>
                    </xsl:variable>
                    <xsl:variable name="pID">
                        <xsl:value-of select="data(substring-after(parent::tei:p/@facs, '#'))" />
                    </xsl:variable>
                    <xsl:variable name="surface" select="//tei:surface/tei:zone[@xml:id = $pID]/parent::tei:surface"/>
                    <xsl:variable name="zones" select="//tei:surface/tei:zone[@xml:id = $pID]/tei:zone[number($idx)]"/>
                    <xsl:attribute name="href">
                        <xsl:value-of select="parent::tei:p/@facs"/>
                        <xsl:text>__p</xsl:text>
                        <xsl:value-of select="$para"/>
                        <xsl:text>__lb</xsl:text>
                        <xsl:value-of select="$lines"/>
                    </xsl:attribute>
                    <xsl:attribute name="name">
                        <xsl:value-of select="parent::tei:p/@facs"/>
                        <xsl:text>__p</xsl:text>
                        <xsl:value-of select="$para"/>
                        <xsl:text>__lb</xsl:text>
                        <xsl:value-of select="$lines"/>
                    </xsl:attribute>
                    <xsl:attribute name="id">
                        <xsl:value-of select="parent::tei:p/@facs"/>
                        <xsl:text>__p</xsl:text>
                        <xsl:value-of select="$para"/>
                        <xsl:text>__lb</xsl:text>
                        <xsl:value-of select="$lines"/>
                    </xsl:attribute>
                    <xsl:attribute name="size">
                        <xsl:value-of select="concat($surface/@lrx, ',' ,$surface/@lry)"/>
                    </xsl:attribute>
                    <xsl:attribute name="zone">
                        <xsl:value-of select="$zones/@points"/>
                    </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="($lines mod 5) = 0">
                            <xsl:attribute name="class">
                                <xsl:text>linenumbersVisible linenumbers</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="data-lbnr">
                                <xsl:value-of select="$lines"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">
                                <xsl:text>linenumbersTransparent linenumbers</xsl:text>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="format-number($lines, '0000')"/>
                </a>
            </xsl:if>
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>
