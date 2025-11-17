<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/" name="tabulator_dl_buttons">
        <div class="d-flex justify-content-end align-items-center gap-2 mb-2">
            <span class="fs-4" data-i18n="download-table"></span>
            <div class="btn-group" role="group" aria-label="Download buttons">
                <button type="button" class="btn" id="download-csv" title="Download CSV">
                    <i class="bi bi-filetype-csv"></i>
                    <span class="visually-hidden">Download CSV</span>
                </button>
                <button type="button" class="btn" id="download-json" title="Download JSON">
                    <i class="bi bi-filetype-json"></i>
                    <span class="visually-hidden">Download JSON</span>
                </button>
                <button type="button" class="btn" id="download-html" title="Download HTML">
                    <i class="bi bi-filetype-html"></i>
                    <span class="visually-hidden">Download HTML</span>
                </button>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>