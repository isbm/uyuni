<%@ taglib uri="http://rhn.redhat.com/rhn" prefix="rhn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<html:xhtml/>
<html>
<head>
  <script src="/javascript/focus.js" type="text/javascript"></script>
</head>
<body onLoad="formFocus('loginForm', 'username')">

<rhn:require acl="not user_authenticated()">

<html:messages id="message" message="true">
    <rhn:messages><c:out escapeXml="false" value="${message}" /></rhn:messages>
</html:messages>
<c:if test="${requestScope.hasExpired != 'true'}">
     <h1><bean:message key="relogin.jsp.pleasesignin"/></h1>
     
     <!-- rhn-upsell-login / -->
     <p><bean:message key="relogin.jsp.relogintext"/></p>
          
  <div class="clearBox">
  <div class="clearBoxInner">
  <div class="clearBoxBody">
    <html:form action="/ReLoginSubmit">
        <%@ include file="/WEB-INF/pages/common/fragments/login_form.jspf" %>
         <html:hidden property="url_bounce" />
    </html:form>
  </div><!-- end clearBoxBody -->
  </div><!-- end clearBoxInner -->
  </div><!-- end clearBox -->
</c:if>
</rhn:require>

</body>
</html>
