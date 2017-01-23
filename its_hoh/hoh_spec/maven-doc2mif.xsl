<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mvn="http://maven.apache.org/XDOC/2.0" xmlns:mif="urn:hl7-org:v3/mif2"
    exclude-result-prefixes="mif mvn" version="2.0">

    <xsl:output use-character-maps="cm1" indent="yes"/>

    <xsl:character-map name="cm1">
        <xsl:output-character character="&#160;" string="&amp;nbsp;"/>
        <xsl:output-character character="&#233;" string="&amp;233;"/>
        <!-- é -->
        <xsl:output-character character="ô" string="&amp;#244;"/>
        <xsl:output-character character="&#8212;" string="--"/>
    </xsl:character-map>

    <xsl:template match="mvn:document">
        <freehandDocument schemaVersion="2.2.1" xmlns="urn:hl7-org:v3/mif2">
            <packageLocation root="BAL" artifact="DC" name="hoh"/>
            <documentContent>
                <text>
                    <xsl:apply-templates select="mvn:body"/>
                </text>
            </documentContent>
        </freehandDocument>
    </xsl:template>

    <xsl:template match="mvn:body">
        <xsl:for-each select="mvn:section">
            <xsl:variable name="sect-id">
                <xsl:call-template name="build-id">
                    <xsl:with-param name="the-name" select="@name"/>
                </xsl:call-template>
            </xsl:variable>
            <div xmlns="urn:hl7-org:v3/mif2">
                <xsl:attribute name="title">
                    <xsl:call-template name="strip-leading-digit">
                        <xsl:with-param name="the-text" select="@name"/>
                    </xsl:call-template>
                </xsl:attribute>
                <xsl:attribute name="hl7Id" select="$sect-id"/>
                <xsl:for-each select="(mvn:p|mvn:img|mvn:ul|mvn:source)[not(@mif-ignore)]">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>

                <xsl:for-each select="mvn:subsection[not(@mif-ignore)]">
                    <xsl:apply-templates select=".">
                        <xsl:with-param name="id-tag" select="$sect-id"/>
                        <xsl:with-param name="seq-num" select="position()"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </div>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="mvn:subsection">
        <xsl:param name="id-tag">temp</xsl:param>
        <xsl:param name="seq-num">0</xsl:param>
        
        <xsl:variable name="my-id" select="concat($id-tag, '.', $seq-num)"/>
        
        <div xmlns="urn:hl7-org:v3/mif2">
            <xsl:attribute name="title">
                <xsl:call-template name="strip-leading-digit">
                    <xsl:with-param name="the-text" select="@name"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="hl7Id" select="$my-id"/>
            
            <xsl:for-each select="(mvn:p|mvn:img|mvn:ul)[not(@mif-ignore)]">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            
            <xsl:for-each select="mvn:subsection[not(@mif-ignore)]">
                <xsl:apply-templates select=".">
                    <xsl:with-param name="id-tag" select="$my-id"/>
                    <xsl:with-param name="seq-num" select="position()"/>
                </xsl:apply-templates>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="mvn:p">
        <p xmlns="urn:hl7-org:v3/mif2">
            <xsl:apply-templates select="node()|text()"/>
        </p>
    </xsl:template>

    <xsl:template match="mvn:img">
        <img xmlns="urn:hl7-org:v3/mif2">
            <xsl:attribute name="src" select="concat('../',@src)"/>
        </img>
    </xsl:template>

    <xsl:template match="mvn:ul">
        <ul xmlns="urn:hl7-org:v3/mif2">
            <xsl:for-each select="mvn:li">
                <li>
                    <xsl:value-of select="text()|node()"/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="mvn:source">
        <source xmlns="urn:hl7-org:v3/mif2">
            <xsl:value-of select="text()"/>
        </source>
    </xsl:template>
    
    <xsl:template match="mvn:code">
        <code xmlns="urn:hl7-org:v3/mif2">
            <xsl:value-of select="text()"/>
        </code>
    </xsl:template>
    
    <xsl:template match="mvn:a">
        <a xmlns="urn:hl7-org:v3/mif2">
            <xsl:attribute name="href" select="@href"/>
            <xsl:value-of select="text()|node()"/>
        </a>
    </xsl:template>
    
    <xsl:template match="mvn:b">
        <b xmlns="urn:hl7-org:v3/mif2">
            <xsl:value-of select="text()"/>
        </b>
    </xsl:template>
    
    <xsl:template match="mvn:br">
        <br xmlns="urn:hl7-org:v3/mif2">
            <xsl:value-of select="text()"/>
        </br>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:copy/>
    </xsl:template>
    
    <xsl:template name="build-id">
        <xsl:param name="the-name"/>
        
        <xsl:variable name="stripped-name" select="replace($the-name, '[ -.]', '')"/>
        <xsl:variable name="no-digits" select="replace($stripped-name, '^[0-9]+', '')"/>
        <xsl:value-of select="$no-digits"/>
    </xsl:template>
    
    <xsl:template name="strip-leading-digit">
        <xsl:param name="the-text"/>
        <xsl:variable name="stripped" select="replace($the-text, '^[0-9-\. ]+', '')"/>
        <xsl:value-of select="$stripped"/>
    </xsl:template>
</xsl:stylesheet>