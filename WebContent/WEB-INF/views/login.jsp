<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login page</title>
    <jsp:include page="head-default.jsp" />
</head>
<body>
    <div class="background"></div>
    
    <div class="centered-card" style="">
        <h2 class="mb-0">Sign in to SpringNewsApp</h2>
        <hr>
        <c:url var="loginUrl" value="/login" />
        <form action="${loginUrl}" method="post" class="form-horizontal" autocomplete="off">
            <c:if test="${param.error != null}">
                <div class="alert alert-danger">
                    <p>Invalid username and password</p>
                </div>
            </c:if>
            <c:if test="${param.logout != null}">
                <div class="alert alert-success">
                    <p>You have been logged out successfully</p>
                </div>
            </c:if>
            <c:if test="${not empty resultsMessage}">
                <div class="alert alert-${status}"><c:out value="${resultsMessage}"/></div>
            </c:if>
            <div class="input-group input-sm">
                <label class="input-group-addon" for="username"><i class="fa fa-user ico-label"></i></label>
                <input type="text" class="form-control" id="username" name="ssoId" placeholder="Enter Username" required />
            </div>
            <div class="input-group input-sm">
                <label class="input-group-addon" for="password"><i class="fa fa-lock ico-label"></i></label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Enter Password" required />
            </div>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="form-actions">
                <input type="submit" class="btn btn-block confirm-button" value="Log in" />
            </div>
            <br>
            <div class="form-actions">
                <a href="<c:url value='/'/>">Go to homepage</a>
                <a class="float-right" href="<c:url value='/users/new'/>">Create new user</a>
            </div>
        </form>
    </div>
</body>
</html>