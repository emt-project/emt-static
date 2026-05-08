<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:template match="/" name="nav_bar">
        <header>
            <nav class="navbar navbar-expand-lg">
                <a class="navbar-brand fs-3 ps-3" href="index.html" data-i18n="navbar__brand"/>
                <div class="container">
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarSupportedContent">
                        <ul class="navbar-nav me-auto mb-2 mb-lg-0 gap-1 fs-4">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" data-i18n="navbar__project" aria-expanded="false" />
                                <ul class=" dropdown-menu" role="menu">
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__about" href="projekt.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__tradition" href="ueberlieferung.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__cipher" href="chiffre.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__edition" href="richtlinien.html" />
                                    </li>
                                    <!-- <li>
                                        <a class="dropdown-item" data-i18n="navbar__howto" href="#" />
                                    </li> -->
                                    <li>
                                        <hr class="dropdown-divider" />
                                    </li>
                                    <li>
                                        <h6 class="dropdown-header" data-i18n="navbar__biogen"/>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__eleonora" href="eleonora.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__johannwilhelm" href="johannwilhelm.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar_philippwilhelm" href="philippwilhelm.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar_gen" href="genealogies.html" />
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="calendar.html" data-i18n="navbar__calendar"></a>
                            </li>
                            <li class="nav-item">
                                <a title="Briefverzeichnis" href="toc.html" class="nav-link" data-i18n="navbar__letterindex"></a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" data-i18n="navbar__register" aria-expanded="false" />
                                <ul class="dropdown-menu" role="menu">
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__persons" href="listperson.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__places" href="listplace.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__orgs" href="listorg.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__attachments" href="attachments.html" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar_timeline" href="timeline.html" />
                                    </li>
                                    <li>
                                        <hr class="dropdown-divider" />
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="cmif.xml">Correspondence Metadata Interchange Format (XML)</a>
                                    </li>
                                </ul>
                            </li>
                            <li class="nav-item">
                                <a title="Team" href="team.html" class="nav-link" data-i18n="navbar__team"></a>
                            </li>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" data-i18n="navbar__publications" aria-expanded="false" />
                                <ul class="dropdown-menu" role="menu">
                                    <li>
                                        <a class="dropdown-item" data-i18n="navbar__blog" href="https://kaiserin.hypotheses.org/" />
                                    </li>
                                </ul>
                            </li>
                        </ul>
                        <div class="d-flex align-items-center ms-2 gap-3">
                            <a title="Suche" href="search.html" class="nav-link fs-3">
                                <i class="bi bi-search"></i>
                            </a>
                            <div class="dropdown">
                                <button class="btn nav-link fs-3 dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" aria-label="Language switcher">
                                    <i class="bi bi-globe"></i>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><button class="dropdown-item" id="lang-switch-de">Deutsch</button></li>
                                    <li><button class="dropdown-item" id="lang-switch-en">English</button></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </header>
    </xsl:template>
</xsl:stylesheet>