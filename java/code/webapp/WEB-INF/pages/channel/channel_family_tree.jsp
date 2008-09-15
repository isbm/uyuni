<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://rhn.redhat.com/rhn" prefix="rhn" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html:xhtml/>
<html>
<head>
<script src="/javascript/channel_tree.js" type="text/javascript"></script>
</head>
<body onLoad="onLoadStuff(1); showAllRows();"> 

<html:messages id="message" message="true">
  <rhn:messages><c:out escapeXml="false" value="${message}" /></rhn:messages>
</html:messages>

<rhn:toolbar base="h1" img="/img/rhn-icon-channels.gif" imgAlt="channels.jsp.alt">
	${requestScope.familyName}
</rhn:toolbar>

<p>
	<bean:message key="entitlements.tree.description1" arg0="${requestScope.familyName}" />
</p>

<p>
	<bean:message key="entitlements.tree.description2" />
</p>

<form method="post" name="rhn_list" action="/rhn/software/channels/All.do">
	<%@ include file="/WEB-INF/pages/common/fragments/channel/channel_tree.jspf" %>
</form>

</body>
</html>