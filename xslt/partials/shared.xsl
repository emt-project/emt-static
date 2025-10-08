<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" exclude-result-prefixes="xs" version="2.0">
    <xsl:function name="local:makeId" as="xs:string">
        <xsl:param name="currentNode" as="node()"/>
        <xsl:variable name="nodeCurrNr">
            <xsl:value-of select="count($currentNode//preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:value-of select="concat(name($currentNode), '__', $nodeCurrNr)"/>
    </xsl:function>

    <xsl:template match="tei:note[not(ancestor::tei:div[@type='attachment']/tei:ab)]">
        <xsl:element name="a">
            <xsl:attribute name="name">
                <xsl:text>fna_</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#fn</xsl:text>
                <xsl:number level="any" format="1" count="tei:note"/>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
            <sup>
                <xsl:number level="any" format="1" count="tei:note"/>
            </sup>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:variable name="reason">
            <xsl:choose>
                <xsl:when test="@reason">
                    <xsl:value-of select="@reason"/>
                </xsl:when>
                <xsl:otherwise>Unklar</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <span tabindex="0" class="unclear" data-bs-toggle="popover" data-bs-content="{$reason}">
            <xsl:apply-templates/>
        </span>

        <xsl:choose>
            <xsl:when test="./following-sibling::node()[1][self::text() = ' ']">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:del">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <xsl:template match="tei:rs">
        <xsl:variable name="entityType">
            <xsl:choose>
                <xsl:when test="contains(data(@ref), 'person') or ./@type='person'">person</xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="contains(data(@ref), 'place') or ./@type='place'">place</xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="contains(data(@ref), 'org') or ./@type='org'">org</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="entityRef">
            <xsl:choose>
                <xsl:when test="starts-with(data(@ref), '#')">
                    <xsl:value-of select="data(@ref)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('#', data(@ref))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
            <span>
                <xsl:if test="@cert">
                    <xsl:attribute name="data-bs-toggle"/>
                    <xsl:attribute name="tabindex">0</xsl:attribute>
                    <xsl:attribute name="data-bs-toggle">popover</xsl:attribute>
                    <xsl:attribute name="data-bs-content">Identifizierung fraglich</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('entity entity-', $entityType)"/>
                </xsl:attribute>
                <xsl:element name="a">
                    <xsl:attribute name="data-bs-toggle">modal</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="contains($entityRef, ' ')">
                            <xsl:variable name="rsCnt">
                                <xsl:number level="any" count="//tei:rs[contains(@ref, ' ')]"/>
                            </xsl:variable>
                            <xsl:attribute name="data-bs-target">
                                <xsl:value-of select="concat(string-join(tokenize($entityRef, ' #')), '--', $rsCnt)"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="data-bs-target">
                                <xsl:value-of select="$entityRef"/>
                            </xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:apply-templates/>
                </xsl:element>
            </span>
        <xsl:choose>
            <xsl:when test="./following-sibling::text()[1][not(starts-with(., ','))]">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:choice">
        <xsl:choose>
            <xsl:when test="./preceding-sibling::node()[1][self::text() = ' ']">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
        <span tabindex="0" class="expan" data-bs-toggle="popover">
            <xsl:attribute name="data-bs-content">Abgekürzt: <xsl:value-of select="./tei:abbr"/>
            </xsl:attribute>
            <xsl:value-of select="./tei:expan/text()"/>
        </span>
        <xsl:choose>
            <xsl:when test="./following-sibling::text()[1][not(starts-with(., ','))]">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:expan"></xsl:template>

    <xsl:template match="tei:unclear[@reason='chiffriert']">
        <span class="unclear-ciphered">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@type='blackening']">
        <span class="seg-blackening">
            <xsl:apply-templates/>
        </span>
        <xsl:choose>
            <xsl:when test="contains(./following-sibling::text()[1], ' ')">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
        <!--<xsl:choose>
            <xsl:when test="./following-sibling::text()[1][not(starts-with(., ','))]"><xsl:text>&#32;</xsl:text></xsl:when>
        </xsl:choose>-->
    </xsl:template>
    <xsl:template match="tei:supplied">
        <span class="supplied">
            <xsl:apply-templates/>
        </span>
        <xsl:choose>
            <xsl:when test="./following-sibling::node()[1][self::text() = ' ']">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add">
        <span class="add">
            <xsl:apply-templates/>
        </span>

    </xsl:template>
    <xsl:template match="tei:abbr">
        <span class="abbr">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:date">
        <span tabindex="0" class="date" data-bs-toggle="popover">
            <xsl:choose>
                <xsl:when test="@when">
                    <xsl:attribute name="data-bs-content">
                        <xsl:value-of select="@when"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@when-iso">
                    <xsl:attribute name="data-bs-content">
                        <xsl:value-of select="@when-iso"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@notBefore and @notAfter">
                    <xsl:attribute name="data-bs-content">
                        <xsl:value-of select="concat('liegt zwischen ', @notBefore, ' und ', @notAfter)"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
        <xsl:choose>
            <xsl:when test="./following-sibling::node()[1][self::text() = ' ']">
                <xsl:text>&#32;</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>