<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    xmlns:mam="whatever" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>



    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')" />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')" />
    </xsl:variable>
    <xsl:import href="info_modal.xsl"/>
    <xsl:template name="header-nav">
        <xsl:param name="doc_title"/>
        <xsl:variable name="correspContext" as="node()?" select=".//tei:correspContext[1]"/>
        <div class="row">
            <div class="col-6">
                <xsl:if test="$correspContext/tei:ref/@subtype = 'previous_letter'">
                    <div class="d-flex flex-column align-items-start">
                        <xsl:if test="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter'][1]">
                            <xsl:for-each select="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'previous_letter'][1]">
                                <a href="{concat(substring-before(@target, '.'), '.html')}" class="btn btn-link d-flex align-items-center" title="{normalize-space(.)}">
                                    <i class="bi bi-chevron-left me-1"/>
                                    <span class="small">Vorheriger Brief</span>
                                </a>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter'][1]">
                            <xsl:for-each select="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'previous_letter'][1]">
                                <a href="{concat(substring-before(@target, '.'), '.html')}" class="btn btn-link d-flex align-items-center" title="{normalize-space(.)}">
                                    <i class="bi bi-chevron-left me-1"/>
                                    <span class="small">... in der Korrespondenz</span>
                                </a>
                            </xsl:for-each>
                        </xsl:if>
                    </div>
                </xsl:if>
            </div>
            <div class="col-6">
                <xsl:if test="$correspContext/tei:ref/@subtype = 'next_letter'">
                    <div class="d-flex flex-column align-items-end">
                        <xsl:if test="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter'][1]">
                            <xsl:for-each select="$correspContext/tei:ref[@type = 'withinCollection' and @subtype = 'next_letter'][1]">
                                <a href="{concat(substring-before(@target, '.'), '.html')}" class="btn btn-link d-flex align-items-center mb-1" title="{normalize-space(.)}">
                                    <span class="small">Nächster Brief</span>
                                    <i class="bi bi-chevron-right ms-1"/>
                                </a>
                            </xsl:for-each>
                        </xsl:if>
                        <xsl:if test="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter'][1]">
                            <xsl:for-each select="$correspContext/tei:ref[@type = 'withinCorrespondence' and @subtype = 'next_letter'][1]">
                                <a href="{concat(substring-before(@target, '.'), '.html')}" class="btn btn-link d-flex align-items-center" title="{normalize-space(.)}">
                                    <span class="small">... in der Korrespondenz</span>
                                    <i class="bi bi-chevron-right ms-1"/>
                                </a>
                            </xsl:for-each>
                        </xsl:if>
                    </div>
                </xsl:if>
            </div>
        </div>
        <h1 class="text-center">
            <xsl:value-of select="$doc_title"/>
        </h1>
        <div class="text-center">
            <button type="button" onclick="window.open('{$teiSource}', '_blank')" class="btn btn-link me-2">
                <i class="bi bi-filetype-xml me-1"/>
                <span>TEI/XML</span>
            </button>
            <button type="button" id="info-modal-trigger" data-bs-toggle="modal" data-bs-target="#exampleModal" class="btn btn-link">
                <i class="bi bi-question-lg me-1"></i>
                <span>Markup-Info</span>
            </button>
        </div>
        <!-- Fixed version of the info modal trigger that shows when scrolling -->
        <div class="position-fixed bottom-0 end-0 p-2 d-none" id="sticky-info" style="z-index: 1030;">
            <button type="button" data-bs-toggle="modal" data-bs-target="#exampleModal" class="btn rounded-circle shadow">
                <i class="bi bi-question-lg"></i>
            </button>
        </div>

        <p class="text-center small">
            <xsl:value-of select="string-join((
     //tei:msDesc/tei:msIdentifier/tei:repository,
     //tei:msDesc/tei:msIdentifier/tei:settlement
  ), ' ')"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="//tei:msDesc/tei:msIdentifier/tei:idno"/>
        </p>

        <!-- Modal -->
        <xsl:call-template name="info_modal"/>

    </xsl:template>

    <xsl:template name="mam:nav-li-item">
        <xsl:param name="eintrag" as="node()"/>
        <xsl:param name="direction"/>
        <xsl:element name="li">
            <xsl:element name="a">
                <xsl:attribute name="id">
                    <xsl:value-of select="$direction"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>dropdown-item</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat(substring-before($eintrag/@target, '.'), '.html')"/>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test="contains($eintrag/@subtype, 'next')">
                        <i class="bi bi-chevron-right"/>
&#160;                                                                                                                                                                                                                                                                                                                                                                                                 <!--
                 -->                    </xsl:when>
                    <xsl:when test="contains($eintrag/@subtype, 'previous')">
                        <i class="bi bi-chevron-left"/>
&#160;                                                                                                                                                                                                                                                                                                                                                                                                 <!--
                 -->                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="$eintrag"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>