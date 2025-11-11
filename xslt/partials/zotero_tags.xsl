<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:template name="zoteroMetaTags">
        <xsl:param name="zoteroTitle" select="false()"></xsl:param>
        <xsl:param name="pageId" select="''"></xsl:param>
        <xsl:param name="pdf" select="''"></xsl:param>
        <xsl:variable name="fullUrl" select="concat($base_url, $pageId)"/>
        <xsl:if test="$zoteroTitle">
            <meta name="citation_title" content="{$zoteroTitle}"/>
            <meta name="citation_book_title" content="{$project_title}"/>
        </xsl:if>  
        <meta name="citation_editors" content="Keller, Katrin; Peper, Ines; Vargová, Dorota; Spitzbart, Anna"/>
        <meta name="citation_date" content="2024"/>
        <meta name="citation_publisher" content="Austrian Centre for Digital Humanities (ACDH)"/>
        <meta name="citation_public_url" content="{$fullUrl}"/>
        <meta name="citation_pdf_url" content="{$pdf}"/>
    </xsl:template>
</xsl:stylesheet>