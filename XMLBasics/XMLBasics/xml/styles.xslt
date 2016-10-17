<?xml version="1.0" encoding="windows-1251"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/">
    <html>
      <body>
        <h1>Students</h1>
        <table bgcolor="#E0E0E0" cellspacing="1">
          <tr bgcolor="#EEEEEE">
            <td>
              <b>Name</b>
            </td>
            <td>
              <b>Gender</b>
            </td>
            <td>
              <b>Phone</b>
            </td>
          </tr>
          <xsl:for-each select="/student">
            <tr bgcolor="white">
              <td>
                <xsl:value-of select="name"></xsl:value-of>
              </td>
              <td>
                <xsl:value-of select="sex"></xsl:value-of>
              </td>
              <td>
                <xsl:value-of select="phone"></xsl:value-of>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>