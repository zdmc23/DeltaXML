<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:deltaxml="https://github.com/laurita/DeltaXML" xmlns:dxa="https://github.com/laurita/DeltaXML" exclude-result-prefixes="xsl deltaxml dxa">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="/">
		<xsl:apply-templates mode="merge"/>
	</xsl:template>
	<xsl:template match="XML" priority="3" mode="merge">
		<XML>
			<xsl:apply-templates mode="merge"/>
		</XML>
	</xsl:template>
	<xsl:template match="node()[@deltaxml:deltaV2='A!=B']" priority="2" mode="merge">
		<xsl:element name="{local-name(.)}">
			<xsl:if test="count(deltaxml:attributes/child::*)>0">
				<xsl:for-each select="deltaxml:attributes//dxa:*">
					<xsl:if test="not(local-name(.)='attributeValue')">
						<xsl:attribute name="{local-name(.)}" select="normalize-space(deltaxml:attributeValue[@deltaxml:deltaV2='B'])"/>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="count(deltaxml:textGroup/child::*)>1">
					<xsl:value-of select="normalize-space(deltaxml:textGroup/deltaxml:text[@deltaxml:deltaV2='B'])"/>
				</xsl:when>
				<xsl:when test="count(deltaxml:textGroup/child::*)>0">
					<xsl:value-of select="normalize-space(deltaxml:textGroup/deltaxml:text[@deltaxml:deltaV2='A'])"/>
				</xsl:when>
				<xsl:otherwise/>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="node()[@deltaxml:deltaV2='A=B' or @deltaxml:deltaV2='A' or @deltaxml:deltaV2='B']" priority="2" mode="merge">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*[not(name()='deltaxml:deltaV2')]|node()" mode="merge"/>
		</xsl:copy>  
	</xsl:template>
	<xsl:template match="text()" priority="1" mode="merge">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>
	<xsl:template match="@*|node()" priority="0" mode="merge">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*|node()" mode="merge"/>
		</xsl:copy>  
	</xsl:template>
</xsl:stylesheet>
