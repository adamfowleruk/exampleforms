<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xf="http://www.w3.org/2002/xforms"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0">
       
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

   <!-- copy and switch to add-ns mode for descendents -->
   <xsl:template match="xf:instance[@id eq 'fr-form-instance' or ends-with(@id, '-template')]">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-ns"/>
      </xsl:copy>
   </xsl:template>

   <!-- copy and switch to add-star mode for descendents -->
   <xsl:template match="xf:bind[@id eq 'fr-form-binds']">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-star"/>
      </xsl:copy>
   </xsl:template>

   <!--
       Mode: add-ns

       Does a recursive descent copy, adding the namespace to
       all elements with no namespace URI.
   -->
   <xsl:template match="node()" mode="add-ns">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-ns"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="*[not(namespace-uri(.))]" mode="add-ns">
      <xsl:element name="{ local-name(.) }" namespace="http://marklogic.com/orbeon-ml-api/ns">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-ns"/>
      </xsl:element>
   </xsl:template>

   <!--
       Mode: add-star

       Does a recursive descent copy, adding "*:" to all bind/@ref
       attributes with no ":" already.
   -->
   <xsl:template match="node()" mode="add-star">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()" mode="add-star"/>
      </xsl:copy>
   </xsl:template>

   <xsl:template match="xf:bind[not(contains(@ref, ':'))]" mode="add-star">
      <xsl:copy>
         <xsl:attribute name="ref" select="concat('*:', @ref)"/>
         <xsl:copy-of select="@* except @ref"/>
         <xsl:apply-templates select="node()" mode="add-star"/>
      </xsl:copy>
   </xsl:template>

</xsl:stylesheet>
