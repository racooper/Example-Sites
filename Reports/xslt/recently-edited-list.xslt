<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
    <xsl:include href="/_cascade/formats/xslt/_common"/>
    <xsl:include href="site://_Common Resources/formats/xslt/format-date"/>
    <xsl:variable name="currentTime" select="/system-index-block/@current-time"/>
    <xsl:variable name="range" select="$currentTime - (/system-index-block/calling-page/system-page/system-data-structure/range * 86400000)"/>
    <xsl:variable name="datetime" select="/system-index-block/calling-page/system-page/system-data-structure/datetime"/>
    <xsl:variable name="timestamp">
        <xsl:choose>
            <xsl:when test="/system-index-block/calling-page/system-page/system-data-structure/filter = 'Range'">
                <xsl:value-of select="$range"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$datetime"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:variable name="recentEdits" select="count(system-index-block/system-page/system-data-structure/block/content/system-index-block//system-page[last-modified&gt;$timestamp][not(@current)])"/>
        <div class="row">
            <div class="col-xs-12">
                <h1>
                    <xsl:value-of select="system-index-block/calling-page/system-page/title"/>
                </h1>
                <p>
                    <xsl:text>Pages edited since </xsl:text>
                    <xsl:call-template name="format-date">
                        <xsl:with-param name="date" select="$timestamp"/>
                        <xsl:with-param name="mask">default</xsl:with-param>
                    </xsl:call-template>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="$recentEdits"/>
                    <xsl:text>. View the table below for the breakdown by Site.</xsl:text>
                </p>
            </div>
        </div>
        <hr/>
        <div class="row">
            <div class="col-xs-12">
                <xsl:choose>
                    <xsl:when test="$recentEdits &gt; 0">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover table-condensed" id="reportTable">
                                <thead>
                                    <tr>
                                        <th>Site</th>
                                        <th>Number of Pages</th>
                                        <th class="col-xs-1 actions">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:apply-templates select="system-index-block/system-page[system-data-structure/block/content/system-index-block//system-page[last-modified&gt;$timestamp][not(@current)]]">
                                        <xsl:sort data-type="text" order="ascending" select="site"/>
                                    </xsl:apply-templates>
                                </tbody>
                            </table>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>Nothing to show here. Go create new content!</p>
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="system-page">
        <tr>
            <td>
                <a href="{link}">
                    <xsl:value-of select="site"/>
                </a>
            </td>
            <td>
                <xsl:value-of select="count(system-data-structure/block/content/system-index-block//system-page[last-modified&gt;$timestamp][not(@current)])"/>
            </td>
            <td>
                <xsl:call-template name="cascadelink">
                    <xsl:with-param name="type">open</xsl:with-param>
                    <xsl:with-param name="pageID" select="@id"/>
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>