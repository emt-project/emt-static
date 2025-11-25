<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/" name="tabulator_js">
        <xsl:param name="addHeaderMenu"/>
        <xsl:param name="counterTranslationKey">default_counter_label</xsl:param>
        <script type="text/javascript" src="vendor/tabulator-tables/js/tabulator.min.js"></script>
        <xsl:if test="$addHeaderMenu = 'true'">
            <script src="tabulator-js/headermenu.js"></script>
        </xsl:if>
        <script src="tabulator-js/config.js"></script>
        <script>
            <xsl:if test="$addHeaderMenu = 'true'">
                config.columnDefaults = {
                    headerMenu: headerMenu
                };
            </xsl:if>
            var table = new Tabulator("#myTable", config);
            const counterKey = "<xsl:value-of select="$counterTranslationKey"/>";
            //trigger download of data.csv file
            document.getElementById("download-csv").addEventListener("click", function(){
            table.download("csv", "data.csv");
            });
            
            //trigger download of data.json file
            document.getElementById("download-json").addEventListener("click", function(){
            table.download("json", "data.json");
            });
            
            //trigger download of data.html file
            document.getElementById("download-html").addEventListener("click", function(){
            table.download("html", "data.html", {style:true});
            });
            
            // link to detail view on row click
            table.on("rowClick", function(e, row){
                var data = row.getData();
                var url = data["itemid"]
                window.open(url);
            });
            let total
            table.on("dataLoaded", function (data) {
                total = data.length;
            })
            table.on("dataFiltered", function(filters, rows){
                let count = rows.length; //get number of rows in table
                const counterText = i18next.t(counterKey, { 
                    count: count, 
                    total: total
                });
                // Need this because i18next is not initialized this event first fires
                if (counterText){
                    document.getElementById("table-counter").innerHTML = counterText;
                }
            });
            // Set initial counter text after i18next is initialized
            i18next.on('initialized', function(options) {
                const counterText = i18next.t(counterKey, { 
                    count: total, 
                    total: total
                });
                document.getElementById("table-counter").innerHTML = counterText;
            });
        </script>
    </xsl:template>
</xsl:stylesheet>