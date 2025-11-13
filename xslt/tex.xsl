<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output encoding="UTF-8" method="text" media-type="text/plain" omit-xml-declaration="true" indent="no"/>


    <!-- Add parameter declaration -->
    <xsl:param name="mode" select="'collection'"/>

    <!-- Main template that handles mode switching -->
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="$mode = 'collection'">
                <xsl:apply-templates select="." mode="collection"/>
            </xsl:when>
            <xsl:when test="$mode = 'document'">
                <xsl:apply-templates select="." mode="document"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="collection"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/" mode="collection">
        <xsl:call-template name="latex-preamble"/>
        <xsl:text>\title{&#10;</xsl:text>
        <xsl:text>Die Korrespondenz der Kaiserin Eleonora Magdalena (1655–1720)}&#10;</xsl:text>
        <xsl:text>\author{EMT Team}&#10;</xsl:text>
        <xsl:text>\date{\today}&#10;</xsl:text>
        <xsl:text>\makeindex[name=person,title=Personenindex,columnsep=14pt,columns=3]&#10;</xsl:text>
        <xsl:text>\makeindex[name=place,title=Ortsindex,columnsep=14pt,columns=3]&#10;</xsl:text>
        <xsl:text>\makeindex[name=org,title=Organisationsindex,columnsep=14pt,columns=3]&#10;</xsl:text>
        <xsl:text>\makeindex[name=sender,title=Briefe nach Absender,columnsep=14pt,columns=2]&#10;</xsl:text>
        <xsl:text>\makeindex[name=recipient,title=Briefe nach Empfänger,columnsep=14pt,columns=2]&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{document}&#10;</xsl:text>
        <xsl:text>\maketitle&#10;</xsl:text>
        <xsl:text>\clearpage&#10;</xsl:text>
        <xsl:text>\begin{center}&#10;</xsl:text>
        <xsl:text>\large&#10;</xsl:text>
        <xsl:text>\section*{Inhaltsverzeichnis}&#10;</xsl:text>
        <xsl:text>\begin{tabular}{@{}l r@{}}&#10;</xsl:text>
        <xsl:text>Briefe &amp; \pageref{letters:start}--\pageref{letters:end} \\&#10;</xsl:text>
        <xsl:text>Personenindex &amp; \pageref{index:person} \\&#10;</xsl:text>
        <xsl:text>Ortsindex &amp; \pageref{index:place} \\&#10;</xsl:text>
        <xsl:text>Organisationsindex &amp; \pageref{index:org} \\&#10;</xsl:text>
        <xsl:text>Briefe nach Absender &amp; \pageref{index:sender} \\&#10;</xsl:text>
        <xsl:text>Briefe nach Empfänger &amp; \pageref{index:recipient} \\&#10;</xsl:text>
        <xsl:text>\end{tabular}&#10;</xsl:text>
        <xsl:text>\end{center}&#10;</xsl:text>
        <xsl:text>\clearpage&#10;</xsl:text>
        <xsl:text>\label{letters:start}&#10;</xsl:text>
        <xsl:for-each select="collection('../data/editions/?select=*.xml')/tei:TEI">
            <xsl:if test="not(.//tei:correspContext//tei:ref[@type='withinCollection' and @subtype='previous_letter'])">
                <!-- This is the first letter, start the chain here -->
                <xsl:call-template name="process-letter-chain">
                    <xsl:with-param name="current-letter" select="."/>
                    <xsl:with-param name="all-letters" select="collection('../data/editions/?select=*.xml')/tei:TEI"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>\label{letters:end}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\newpage&#10;</xsl:text>
        <xsl:text>\back\small&#10;</xsl:text>
        <xsl:text>\label{index:person}&#10;</xsl:text>
        <xsl:text>\printindex[person]&#10;</xsl:text>
        <xsl:text>\label{index:place}&#10;</xsl:text>
        <xsl:text>\printindex[place]&#10;</xsl:text>
        <xsl:text>\label{index:org}&#10;</xsl:text>
        <xsl:text>\printindex[org]&#10;</xsl:text>
        <xsl:text>\label{index:sender}&#10;</xsl:text>
        <xsl:text>\printindex[sender]&#10;</xsl:text>
        <xsl:text>\label{index:recipient}&#10;</xsl:text>
        <xsl:text>\printindex[recipient]&#10;</xsl:text>
        <xsl:text>\end{document}&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="/" mode="document">
        <xsl:call-template name="latex-preamble"/>
        <xsl:text>\title{&#10;</xsl:text>
        <xsl:value-of select="normalize-space(.//tei:titleStmt/tei:title[1]/text())"/>
        <xsl:text>}&#10;</xsl:text>
        <xsl:text>\author{}&#10;</xsl:text>
        <xsl:text>\date{}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\begin{document}&#10;</xsl:text>
        <xsl:text>\maketitle&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <!-- Process the single letter content -->
        <xsl:call-template name="process-letter-content">
            <xsl:with-param name="letter" select="./tei:TEI"/>
        </xsl:call-template>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>\end{document}&#10;</xsl:text>
    </xsl:template>

    <xsl:template name="latex-preamble">
        <xsl:text>\documentclass[a4paper]{article}&#10;</xsl:text>
        <xsl:text>\usepackage{polyglossia}&#10;</xsl:text>
        <xsl:text>\setmainlanguage{german}&#10;</xsl:text>
        <xsl:text>\usepackage{soul}&#10;</xsl:text>
        <xsl:text>\usepackage{imakeidx}&#10;</xsl:text>
        <xsl:text>\usepackage[hidelinks]{hyperref}&#10;</xsl:text>
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
    </xsl:template>

    <xsl:template name="process-letter-chain">
        <xsl:param name="current-letter"/>
        <xsl:param name="all-letters"/>
        <xsl:variable name="title">
            <xsl:value-of select="normalize-space($current-letter//tei:titleStmt/tei:title[1]/text())"/>
        </xsl:variable>
        <xsl:variable name="sender" select="$current-letter//tei:correspDesc/tei:correspAction[@type='sent']/tei:persName"/>
        <xsl:variable name="recipient" select="$current-letter//tei:correspDesc/tei:correspAction[@type='received']/tei:persName"/>
        <xsl:text>\section*{</xsl:text>
        <xsl:value-of select="$title"/>
        <xsl:text>}&#10;</xsl:text>
        <xsl:text>\index[sender]{</xsl:text>
        <xsl:value-of select="$sender"/>
        <xsl:text>}&#10;</xsl:text>
        <xsl:text>\index[recipient]{</xsl:text>
        <xsl:value-of select="$recipient"/>
        <xsl:text>}&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:call-template name="process-letter-content">
            <xsl:with-param name="letter" select="$current-letter"/>
        </xsl:call-template>
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

    <xsl:template name="process-letter-content">
        <xsl:param name="letter"/>
        <!-- Metadata section -->
        <xsl:text>\small&#10;</xsl:text>
        <xsl:text>\noindent </xsl:text>
        <xsl:text>\textsc{</xsl:text>
        <xsl:value-of select="string-join((
            $letter//tei:msDesc/tei:msIdentifier/tei:repository,
            $letter//tei:msDesc/tei:msIdentifier/tei:settlement
        ), ' ')"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="$letter//tei:msDesc/tei:msIdentifier/tei:idno"/>
        <xsl:text>}</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:if test="$letter//tei:profileDesc/tei:abstract/tei:ab[@type='abstract-terms']">
            <xsl:text>\\&#10;</xsl:text>
            <xsl:text>\noindent </xsl:text>
            <xsl:text>Briefattribute: </xsl:text>
            <xsl:for-each select="$letter//tei:profileDesc/tei:abstract/tei:ab[@type='abstract-terms']/tei:term">
                <xsl:if test="position() > 1">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:text>&#10;</xsl:text>
        </xsl:if>

        <!-- Regest -->
        <xsl:if test="$letter//tei:profileDesc/tei:abstract[@n='regest']">
            <xsl:text>\par&#10;</xsl:text>
            <xsl:text>\textit{</xsl:text>
            <xsl:apply-templates select="$letter//tei:profileDesc/tei:abstract[@n='regest']"/>
            <xsl:text>}&#10;</xsl:text>
        </xsl:if>

        <!-- Letter body content -->
        <xsl:for-each select="$letter//tei:body//tei:div[@type='page']">
            <xsl:if test=".//tei:p[normalize-space(.)]">
                <xsl:text>\hfill \textit{</xsl:text>
                <xsl:value-of select=".//tei:pb/@n"/>
                <xsl:text>}</xsl:text>
                <xsl:for-each select=".//tei:p[normalize-space(.)]">
                    <xsl:text>\par&#10;</xsl:text>
                    <xsl:if test="position()=1">
                        <xsl:text>\noindent </xsl:text>
                    </xsl:if>
                    <xsl:apply-templates/>
                    <xsl:text>\par&#10;</xsl:text>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:text>\newline&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="tei:del">
        <xsl:call-template name="add-space-before"/>
        <xsl:text>\st{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
        <xsl:call-template name="add-space-after"/>
    </xsl:template>
    <xsl:template match="tei:seg[@type='blackening']">
        <xsl:call-template name="add-space-before"/>
        <xsl:text>\st{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
        <xsl:call-template name="add-space-after"/>
    </xsl:template>
    <xsl:template match="tei:note">
        <xsl:text>\footnote{</xsl:text>
        <xsl:apply-templates/>
        <xsl:if test="normalize-space(.) != '' and not(ends-with(normalize-space(.), '.'))">
            <xsl:text>.</xsl:text>
        </xsl:if>
        <xsl:text>}</xsl:text>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <xsl:call-template name="add-space-before"/>
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}[?]</xsl:text>
        <xsl:call-template name="add-space-after"/>
    </xsl:template>
    <xsl:template match="tei:choice">
        <xsl:call-template name="add-space-before"/>
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates select="tei:expan"/>
        <xsl:text>}</xsl:text>
        <xsl:call-template name="add-space-after"/>
    </xsl:template>
    <xsl:template match="tei:date">
        <xsl:call-template name="add-space-before"/>
        <xsl:apply-templates/>
        <xsl:call-template name="add-space-after"/>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:call-template name="add-space-before"/>
        <xsl:variable name="rstype" select="@type"/>
        <xsl:variable name="rsid" select="substring-after(@ref, '#')"/>
        <xsl:variable name="ent" select="root()//tei:back//*[@xml:id=$rsid]"/>
        <xsl:variable name="idxlabel" select="$ent/*[contains(name(), 'Name')][1]"/>
        <xsl:value-of select="'\index['||$rstype||']{'||$idxlabel||'} '"/>
        <xsl:apply-templates/>
        <xsl:variable name="footnotetext">
            <xsl:choose>
                <xsl:when test="$rstype = 'person'">
                    <xsl:variable name="birth" select="$ent/tei:birth/tei:date"/>
                    <xsl:variable name="death" select="$ent/tei:death/tei:date"/>
                    <xsl:value-of select="$idxlabel"/>
                    <xsl:if test="$birth or $death">
                        <xsl:text> (</xsl:text>
                        <xsl:choose>
                            <xsl:when test="$birth">
                                <xsl:value-of select="$birth"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>?</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                            <xsl:text>–</xsl:text>
                        <xsl:choose>
                            <xsl:when test="$death">
                                <xsl:value-of select="$death"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>?</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                    <xsl:if test="$ent/tei:persName[@type='title']">
                        <xsl:text>, </xsl:text>
                        <xsl:for-each select="$ent/tei:persName[@type='title']">
                            <xsl:if test="position() > 1">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="./tei:roleName"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="$ent/tei:persName[@type='function']">
                        <xsl:text>, </xsl:text>
                        <!-- for function there can only be one-->
                        <xsl:value-of select="$ent/tei:persName[@type='function']/tei:roleName/text()"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$idxlabel"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:text>\footnote{</xsl:text><xsl:value-of select="$footnotetext"/><xsl:if test="not(ends-with(normalize-space($footnotetext), '.'))"><xsl:text>.</xsl:text></xsl:if><xsl:text>}</xsl:text>
        <xsl:call-template name="add-space-after"/>
    </xsl:template>
    <!-- supplied and add require different space handling because they might occur mid-word -->
    <xsl:template match="tei:supplied">
        <xsl:if test="preceding-sibling::text()[1][matches(., '\s$')]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
        <xsl:if test="following-sibling::text()[1][matches(., '^\s')]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:add">
        <xsl:if test="preceding-sibling::text()[1][matches(., '\s$')]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>]</xsl:text>
        <xsl:if test="following-sibling::text()[1][matches(., '^\s')]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:variable name="text" select="normalize-space(.)"/>
        <xsl:if test="$text != ''">
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

    <xsl:template name="add-space-before">
        <xsl:if test="preceding-sibling::node()[1][
           ( self::text()[normalize-space(.) != ''] or
            self::tei:expan or
            self::tei:rs or
            self::tei:unclear or self::tei:seg[@type='blackening'] or
            self::tei:del or
            self::tei:date ) and
            not(self::tei:lb)
        ]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template name="add-space-after">
        <xsl:if test="following-sibling::node()[1][
                        (
                        self::text()[
                            normalize-space(.) != '' and
                            not(matches(., '^[\p{P}\p{S}]'))
                        ]
                        or self::tei:expan
                        or self::tei:rs
                        or self::tei:unclear
                        or self::tei:seg[@type='blackening']
                        or self::tei:del
                        )
                    ]">
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>