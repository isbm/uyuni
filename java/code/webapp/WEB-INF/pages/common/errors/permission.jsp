<%@ taglib uri="http://rhn.redhat.com/rhn" prefix="rhn" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<html:xhtml/>
<html>
<body>

<h1>
  <img src="/img/rhn-icon-warning.gif"
       alt="<bean:message key='error.common.errorAlt' />" />
  ${error.localizedTitle}
</h1>

<p>${error.localizedSummary}</p>

</body>
</html>