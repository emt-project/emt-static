<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output encoding="UTF-8" method="text" media-type="text/plain" omit-xml-declaration="true" indent="no"/>

    <xsl:template match="/">
        <xsl:text>\documentclass[a4paper]{article}&#10;</xsl:text>
        <xsl:text>\usepackage{polyglossia}&#10;</xsl:text>
        <xsl:text>\setmainlanguage{german}&#10;</xsl:text>
        <xsl:text>\usepackage{soul}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\usepackage{imakeidx}&#10;</xsl:text>
        <xsl:text>\makeatletter&#10;</xsl:text>
        <xsl:text>% we don't want a page break before the first subitem&#10;</xsl:text>
        <xsl:text>% https://tex.stackexchange.com/questions/130169/how-can-i-prevent-a-column-break-before-the-first-sub-entry-in-the-index&#10;</xsl:text>
        <xsl:text>% set index indent to 6pt &#10;</xsl:text>
        <xsl:text>\newif\iffirst@subitem&#10;</xsl:text>
        <xsl:text>\def\@idxitem{%&#10;</xsl:text>
        <xsl:text>\pagebreak[2]\par\hangindent6\p@ % original&#10;</xsl:text>
        <xsl:text>\first@subitemtrue   % added&#10;</xsl:text>
        <xsl:text>}&#10;</xsl:text>
        <xsl:text>\def\subitem{%&#10;</xsl:text>
        <xsl:text>\par\hangindent12\p@~–\,&#10;</xsl:text>
        <xsl:text>    \iffirst@subitem&#10;</xsl:text>
        <xsl:text>    \nobreak&#10;</xsl:text>
        <xsl:text>    \first@subitemfalse&#10;</xsl:text>
        <xsl:text>    \fi&#10;</xsl:text>
        <xsl:text>    \hspace*{2\p@}}&#10;</xsl:text>
        <xsl:text>    \makeatother&#10;</xsl:text>
        <xsl:text>\setlength\parindent{2.6em}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\title{&#10;</xsl:text>
        <xsl:text>Die Korrespondenz der Kaiserin Eleonora Magdalena (1655–1720)}&#10;</xsl:text>
        <xsl:text>\author{EMT Team}&#10;</xsl:text>
        <xsl:text>\date{\today} \makeindex[name=person,title=Personenindex,columnsep=14pt,columns=3] \makeindex[name=place,title=Ortsindex,columnsep=14pt,columns=3] \makeindex[name=org,title=Institutionsindex,columnsep=14pt,columns=3] \makeindex[name=letter,title=Briefindex,columnsep=14pt,columns=3]&#10;</xsl:text>
        <xsl:text>\usepackage[hidelinks]{hyperref}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{document}&#10;</xsl:text>
        <xsl:text>\maketitle&#10;</xsl:text>
        <xsl:text>\clearpage&#10;</xsl:text>
        <xsl:text>\tableofcontents&#10;</xsl:text>
        <xsl:text>\clearpage&#10;</xsl:text>
        <xsl:for-each select="collection('../data/editions/?select=*.xml')/tei:TEI">
            <xsl:if test="not(.//tei:correspContext//tei:ref[@type='withinCollection' and @subtype='previous_letter'])">
                <!-- This is the first letter, start the chain here -->
                <xsl:call-template name="process-letter-chain">
                    <xsl:with-param name="current-letter" select="."/>
                    <xsl:with-param name="all-letters" select="collection('../data/editions/?select=*.xml')/tei:TEI"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\newpage&#10;</xsl:text>
        <xsl:text>\back\small&#10;</xsl:text>
        <xsl:text>\printindex[person]&#10;</xsl:text>
        <xsl:text>\printindex[place]&#10;</xsl:text>
        <xsl:text>\printindex[org]&#10;</xsl:text>
        <xsl:text>\printindex[letter]&#10;</xsl:text>
        <xsl:text>\end{document}&#10;</xsl:text>
    </xsl:template>


    <xsl:template name="process-letter-chain">
        <xsl:param name="current-letter"/>
        <xsl:param name="all-letters"/>
        <xsl:variable name="docId">
            <xsl:value-of select="replace($current-letter/@xml:id, '.xml', '')"/>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:value-of select="$current-letter//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <xsl:text>\section{</xsl:text><xsl:value-of select="$title"/><xsl:text>}&#10;</xsl:text>
        <xsl:text>\index[letter]{</xsl:text><xsl:value-of select="$title"/><xsl:text>}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{quote}&#10;</xsl:text>
        <xsl:text>\small&#10;</xsl:text>
        <xsl:text>\textsc{</xsl:text>
        <xsl:value-of select="string-join((
            $current-letter//tei:msDesc/tei:msIdentifier/tei:repository,
            $current-letter//tei:msDesc/tei:msIdentifier/tei:settlement
        ), ' ')"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$current-letter//tei:msDesc/tei:msIdentifier/tei:idno"/>
        <xsl:text>}</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:if test="$current-letter//tei:profileDesc/tei:abstract/tei:ab[@type='abstract-terms']">
            <xsl:text>\\&#10;</xsl:text>
            <xsl:text>Briefattribute: </xsl:text>
            <xsl:for-each select="$current-letter//tei:profileDesc/tei:abstract/tei:ab[@type='abstract-terms']/tei:term">
                <xsl:if test="position() > 1"><xsl:text>, </xsl:text></xsl:if>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
        </xsl:if>
        <xsl:text>\end{quote}&#10;</xsl:text>
        <xsl:if test="$current-letter//tei:profileDesc/tei:abstract[@n='regest']">
            <xsl:text>\par&#10;</xsl:text>
            <xsl:text>\textit{</xsl:text>
            <xsl:apply-templates select="$current-letter//tei:profileDesc/tei:abstract[@n='regest']"/>
            <xsl:text>}&#10;</xsl:text>
        </xsl:if>
        <xsl:for-each select="$current-letter//tei:body//tei:div[@type='page']">
            <xsl:text>\hfill \textit{</xsl:text><xsl:value-of select=".//tei:pb/@n"/><xsl:text>}</xsl:text>
            <xsl:for-each select=".//tei:p[normalize-space(.)]">
                <xsl:text>\par&#10;</xsl:text>
                <xsl:if test="position()=1"><xsl:text>\noindent </xsl:text></xsl:if>
                <xsl:apply-templates/>
                <xsl:text>\par&#10;</xsl:text>
            </xsl:for-each>
        </xsl:for-each>

        <!-- Find next letter using next_letter reference -->
        <xsl:variable name="next-ref" select="$current-letter//tei:correspContext//tei:ref[@type='withinCollection' and @subtype='next_letter']/@target"/>
        <xsl:if test="$next-ref">
            <xsl:variable name="next-letter" select="$all-letters[@xml:id = $next-ref]"/>
            <xsl:if test="$next-letter">
                <xsl:call-template name="process-letter-chain">
                    <xsl:with-param name="current-letter" select="$next-letter"/>
                    <xsl:with-param name="all-letters" select="$all-letters"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:text>\newline </xsl:text>
    </xsl:template>

    <xsl:template match="tei:del">
        <xsl:text>\st{</xsl:text><xsl:value-of select="."/><xsl:text>}&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:seg[@type='blackening']">
        <xsl:text>\st{</xsl:text><xsl:value-of select="."/><xsl:text>}&#10;</xsl:text>
    </xsl:template>
    <xsl:template match="tei:note">
        <xsl:text>\footnote{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:text>\textit{</xsl:text><xsl:apply-templates/><xsl:text>}[?]</xsl:text>
    </xsl:template>
    <xsl:template match="tei:choice">
        <!-- Add space before if previous sibling is also a choice or other inline element -->
        <xsl:if test="preceding-sibling::node()[1][self::tei:choice or self::tei:rs or self::tei:unclear]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
        <xsl:text>\textit{</xsl:text><xsl:apply-templates select="tei:expan"/><xsl:text>}</xsl:text>

        <!-- Add space after if next sibling is also a choice or other inline element -->
        <xsl:if test="following-sibling::node()[1][self::tei:choice or self::tei:rs or self::tei:unclear]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:supplied">
        <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="tei:add">
        <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:variable name="rstype" select="@type"/>
        <xsl:variable name="rsid" select="substring-after(@ref, '#')"/>
        <xsl:variable name="ent" select="root()//tei:back//*[@xml:id=$rsid]"/>
        <xsl:variable name="idxlabel" select="$ent/*[contains(name(), 'Name')][1]"/>
        <xsl:value-of select="'\index['||$rstype||']{'||$idxlabel||'} '"/>
        <xsl:apply-templates/>
        <xsl:text>\footnote{</xsl:text><xsl:value-of select="$idxlabel"/><xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:variable name="text" select="."/>
        <xsl:if test="normalize-space($text) != ''">
            <xsl:analyze-string select="$text" regex="[#\$%&amp;_{}~^\\]">
                <xsl:matching-substring>
                    <xsl:choose>
                        <xsl:when test=". = '#'">\#</xsl:when>
                        <xsl:when test=". = '$'">\$</xsl:when>
                        <xsl:when test=". = '%'">\%</xsl:when>
                        <xsl:when test=". = '&amp;'">\&amp;</xsl:when>
                        <xsl:when test=". = '_'">\_</xsl:when>
                        <xsl:when test=". = '{'">\{</xsl:when>
                        <xsl:when test=". = '}'">\}</xsl:when>
                        <xsl:when test=". = '~'">\textasciitilde{}</xsl:when>
                        <xsl:when test=". = '^'">\textasciicircum{}</xsl:when>
                        <xsl:when test=". = '\'">\textbackslash{}</xsl:when>
                    </xsl:choose>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>