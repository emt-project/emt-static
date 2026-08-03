<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:template match="tei:listBibl">
    <ul class="list-unstyled bibliography lh-lg">
        <xsl:apply-templates select="tei:biblStruct">
            <xsl:sort select="(tei:analytic/tei:author[1]/tei:surname | tei:monogr/tei:editor[1]/tei:surname)[1]" lang="de"/>
        </xsl:apply-templates>
    </ul>
    </xsl:template>

   
    <xsl:template match="tei:biblStruct">
    <li class="pb-2">
        <xsl:choose>
            <xsl:when test="@type='journalArticle'">
                <xsl:apply-templates select="." mode="journalArticle" />
            </xsl:when>
            <xsl:when test="@type='bookSection'">
                <xsl:apply-templates select="." mode="bookSection" />
            </xsl:when>
            <xsl:when test="@type='book'">
                <xsl:apply-templates select="." mode="book" />
            </xsl:when>
            <xsl:when test="@type='webpage'">
                <xsl:apply-templates select="." mode="webpage" />
            </xsl:when>
        </xsl:choose>
    </li>
    </xsl:template>

    <xsl:template match="tei:biblStruct" mode="journalArticle">
        <xsl:apply-templates select="tei:analytic/tei:author" />
        <xsl:text>: "</xsl:text>
        <xsl:apply-templates select="tei:analytic/tei:title" />
        <xsl:text>", in: </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:title" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:biblScope[@unit='volume']" />
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:date" />
        <xsl:text>), </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']" />
    </xsl:template>

    <xsl:template match="tei:biblStruct" mode="bookSection">
        <xsl:apply-templates select="tei:analytic/tei:author" />
        <xsl:text>: "</xsl:text>
        <xsl:apply-templates select="tei:analytic/tei:title" />
        <xsl:text>", in: </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:editor" />
        <xsl:text> (Hg.), </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:title" />
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="tei:series/tei:title" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:biblScope[@unit='volume']" />
        <xsl:text>), </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:pubPlace" />
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:publisher" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:date" />
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:biblScope[@unit='page']" />
    </xsl:template>

    <xsl:template match="tei:biblStruct" mode="book">
        <xsl:apply-templates select="tei:monogr/tei:editor" />
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:title" />
        <xsl:text>, </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:pubPlace" />
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:publisher" />
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:date" />
    </xsl:template>

    <xsl:template match="tei:biblStruct" mode="webpage">
        <xsl:apply-templates select="tei:analytic/tei:author" />
        <xsl:text>: "</xsl:text>
        <xsl:apply-templates select="tei:analytic/tei:title" />
        <xsl:text>". </xsl:text>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="tei:monogr/tei:imprint/tei:date" />
        <xsl:text>)</xsl:text>
    </xsl:template>

    <xsl:template match="tei:author">
        <xsl:choose>
            <xsl:when test="last() > 3">
                <xsl:if test="position() = 1">
                    <xsl:apply-templates select="tei:surname" />
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="tei:forename" />
                    <xsl:text> et al.</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="position() > 1">
                    <xsl:text> und </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="tei:surname" />
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="tei:forename" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:editor">
        <xsl:choose>
            <xsl:when test="last() > 3">
                <xsl:if test="position() = 1">
                    <xsl:apply-templates select="tei:surname" />
                    <xsl:text>, </xsl:text>
                    <xsl:apply-templates select="tei:forename" />
                    <xsl:text> et al.</xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="position() > 1">
                    <xsl:text> und </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="tei:surname" />
                <xsl:text>, </xsl:text>
                <xsl:apply-templates select="tei:forename" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:title">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="tei:biblStruct/tei:analytic/tei:title">
        <xsl:variable name="url" select="ancestor::tei:biblStruct//tei:note[@type='url']"/>
        <xsl:choose>
            <xsl:when test="$url">
                <a href="{$url}"><xsl:value-of select="."/></a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:biblScope">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="tei:date">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="tei:pubPlace">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="tei:publisher">
        <xsl:value-of select="." />
    </xsl:template>

</xsl:stylesheet>
