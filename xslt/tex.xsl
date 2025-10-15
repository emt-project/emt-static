<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output encoding="UTF-8" media-type="text" omit-xml-declaration="true" indent="no"/>

    <xsl:template match="/">
        <xsl:text>\documentclass[a4paper]{article}</xsl:text>
        <xsl:text>\usepackage{polyglossia}</xsl:text>
        <xsl:text>\setmainlanguage{german}</xsl:text>



\usepackage{imakeidx}
\makeatletter
% we don't want a page break before the first subitem
% https://tex.stackexchange.com/questions/130169/how-can-i-prevent-a-column-break-before-the-first-sub-entry-in-the-index
% set index indent to 6pt 
\newif\iffirst@subitem
\def\@idxitem{%
\pagebreak[2]\par\hangindent6\p@ % original
\first@subitemtrue   % added
}
\def\subitem{%
\par\hangindent12\p@~–\,
    \iffirst@subitem
    \nobreak
    \first@subitemfalse
    \fi
    \hspace*{2\p@}}
    \makeatother
\setlength\parindent{2.6em}


\title{
Die Korrespondenz der Kaiserin Eleonora Magdalena (1655–1720)}
\author{EMT Team}
\date{today} \makeindex[name=person,title=Personenindex,columnsep=14pt,columns=3] \makeindex[name=place,title=Ortsindex,columnsep=14pt,columns=3] \makeindex[name=org,title=Institutionsindex,columnsep=14pt,columns=3] \makeindex[name=letter,title=Briefindex,columnsep=14pt,columns=3]
\usepackage[hidelinks]{hyperref}

\begin{document}
\maketitle
\clearpage
\tableofcontents
\clearpage
        <xsl:for-each select="collection('../data/editions/?select=*.xml')/tei:TEI">
            <xsl:sort select="./@xml:id"></xsl:sort>
            <xsl:variable name="docId">
                <xsl:value-of select="replace(./@xml:id, '.xml', '')"/>
            </xsl:variable>
            <xsl:variable name="title">
                <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
            </xsl:variable>
\section{
            <xsl:value-of select="$title"/>
}
\index[letter]{<xsl:value-of select="$title"/>
}

        <xsl:for-each select=".//tei:body//tei:div[@type='page']">



            <xsl:for-each select=".//tei:p[normalize-space(.)]">
    \par
                <xsl:if test="position()=1">\noindent </xsl:if>
                <xsl:apply-templates/>
    \par 
            </xsl:for-each>


        </xsl:for-each>
    </xsl:for-each>

\newpage
\back\small
\printindex[person]
\printindex[place]
\printindex[org]
\printindex[letter]
\end{document}
        
</xsl:template>

<xsl:template match="tei:lb">
    <xsl:text>\newline </xsl:text>
</xsl:template>

<xsl:template match="tei:del">\sout{<xsl:value-of select="."/>
}</xsl:template>
<xsl:template match="tei:note">
\footnote{<xsl:apply-templates/>
}
</xsl:template>
<xsl:template match="tei:unclear">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
</xsl:template>
<xsl:template match="tei:choice">
    <!-- Add space before if previous sibling is also a choice or other inline element -->
    <xsl:if test="preceding-sibling::node()[1][self::tei:choice or self::tei:rs or self::tei:unclear]">
        <xsl:text>&#32;</xsl:text>
    </xsl:if>

    <xsl:text>\textit{</xsl:text>
    <xsl:apply-templates select="tei:expan"/>
    <xsl:text>}</xsl:text>

    <!-- Add space after if next sibling is also a choice or other inline element -->
    <xsl:if test="following-sibling::node()[1][self::tei:choice or self::tei:rs or self::tei:unclear]">
        <xsl:text>&#32;</xsl:text>
    </xsl:if>
</xsl:template>
<xsl:template match="tei:rs">
    <xsl:variable name="rstype" select="@type"/>
    <xsl:variable name="rsid" select="substring-after(@ref, '#')"/>
    <xsl:variable name="ent" select="root()//tei:back//*[@xml:id=$rsid]"/>
    <xsl:variable name="idxlabel" select="$ent/*[contains(name(), 'Name')][1]"/>
    <xsl:value-of select="'\index['||$rstype||']{'||$idxlabel||'} '"/>
    <xsl:apply-templates/>
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