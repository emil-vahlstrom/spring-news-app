<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Result</title>
<link href="<c:url value='/css/bootstrap.css'/>" rel="stylesheet"></link>
<link href="<c:url value='/css/app.css'/>" rel="stylesheet"></link>
<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <div id="mainWrapper">
        <div class="login-container">
            <div class="login-card">
                <div class="login-form">
                    <div class="alert alert-${status}">
                        ${resultsMessage}
                    </div>
                    <div class="form-actions">
                        <a href="<c:url value='${linkHref}'/>"><c:out value="${linkTitle}" /></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>