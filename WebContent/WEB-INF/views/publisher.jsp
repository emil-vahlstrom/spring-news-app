<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Publisher</title>
    <jsp:include page="head-default.jsp" />
</head>
<body>
    <h1>Publisher Page</h1>
    <a href="<c:url value='/news/new' />">Write News</a> | 
    <a href="<c:url value='/logout' />">Logout</a> | 
    <a href="<c:url value='/' />">Go to Home</a>
</body>
</html>