<?xml version="1.0" encoding="UTF-8"?>
<html xsl:version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<head>
<script type="text/javascript" src="report.js">
</script>
</head>
  <body style="font-family:Arial;font-size:8pt;background-color:#EEEEEE">
    <div onclick="javascript:showhide('github');" title="Click to Expand/Collapse"><h2>GitHub Open source</h2>
    </div>
    <div align="center">
    <table id="github" style='width:90%; align:center; border-collapse: collapse;'>
      <tr>
       <th title="Click to sort" onclick="sortTable('github', 0)">Package name</th>
       <th title="Click to sort" onclick="sortTable('github', 1)">GitHub user</th>
       <th title="Click to sort" onclick="sortTable('github', 2)">GitHub repo name</th>
       <th title="Click to sort" onclick="sortTable('github', 3)">Source</th>
       <th title="Click to sort" onclick="sortTable('github', 4)">Updated ? (Yes/No)</th>
       <th title="Click to sort" onclick="sortTable('github', 5)">Active ? (Yes/No)</th>
       <th title="Click to sort" onclick="sortTable('github', 6)">Local modified date</th>
       <th title="Click to sort" onclick="sortTable('github', 7)">Latest release date</th>
      </tr>
    <xsl:for-each select="packages/key">
      <tr>
      <td>
      <div style="background-color:teal;color:white;padding:4px">
	<xsl:attribute name="title">Click to view full directory path.</xsl:attribute>
	<xsl:attribute name="onclick">
	  javascript:showhide('id-<xsl:value-of select="Package" />');
	</xsl:attribute>
        <span style="font-weight:bold"><xsl:value-of select="Package"/></span>
      </div>
      <div style="display:none">
	<xsl:attribute name="id">id-<xsl:value-of select="Package" /></xsl:attribute>
	Directory path: 
	<a target="_blank">
	  <xsl:attribute name="href">file://<xsl:value-of select="@name"/></xsl:attribute>
	  <xsl:value-of select="@name"/>
	</a>
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
      <td style="padding:0 15px" align="center"><xsl:value-of select="Source"/></td>
      <td style="padding:0 15px" align="center"><xsl:value-of select="Updated"/></td>
      <td style="padding:0 15px" align="center"><xsl:value-of select="Active"/></td>
      <td style="padding:0 15px" align="center"><xsl:value-of select="Local"/></td>
      <td style="padding:0 15px" align="center"><xsl:value-of select="Latest"/></td>
      </tr>
    </xsl:for-each>
    </table></div>
  </body>
</html>
