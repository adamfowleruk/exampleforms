<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:esif="http://marklogic.com/orbeon-ml-api/ns"
                xmlns:sem="http://marklogic.com/semantics"
                version="2.0">

   <xsl:output indent="yes"/>

   <!-- Identity template : copy all text nodes, elements and attributes -->   
   <xsl:template match="@*|node()">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
   </xsl:template>

   <!-- When matching the following: do nothing -->
   <xsl:template match="sem:triples"/>   

</xsl:stylesheet>
