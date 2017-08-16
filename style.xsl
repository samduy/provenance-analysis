<?xml version="1.0" encoding="UTF-8"?>
<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <body style="font-family:Arial;font-size:8pt;background-color:#EEEEEE">
    <table style='width:90%; align:center; border-collapse: collapse;'>
    <xsl:for-each select="packages/key">
      <tr>
      <td>
      <div style="background-color:teal;color:white;padding:4px">
        <span style="font-weight:bold"><xsl:value-of select="Package"/></span>
      </div>
      </td>
      <td><a target="_blank">
	<xsl:attribute name="href">
	http://www.github.com/<xsl:value-of select="github_user"/>
	</xsl:attribute>
	<xsl:value-of select="github_user"/>
      </a></td>
      <td><a target="_blank">
	<xsl:attribute name="href">
	http://www.github.com/<xsl:value-of select="github_user"/>/<xsl:value-of select="github_repo"/>
	</xsl:attribute>
	<xsl:value-of select="github_repo"/>
      </a></td>
      <td style="padding:0 15px"><xsl:value-of select="Source"/></td>
      <td style="padding:0 15px"><xsl:value-of select="Updated"/></td>
      <td style="padding:0 15px"><xsl:value-of select="Active"/></td>
      <td style="padding:0 15px"><xsl:value-of select="Local"/></td>
      <td>
        <xsl:value-of select="Latest"/>
      </td>
      </tr>
    </xsl:for-each>
    </table>
  </body>
</html>
