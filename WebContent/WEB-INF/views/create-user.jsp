<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Create User</title>
    <jsp:include page="head-default.jsp"/>
</head>
<body>
    <div class="background"></div>
    
    <div class="centered-card">
        <h2 class="mb-0">Create User</h2>
        <hr>
        <jsp:include page="user-form.jsp"/>
        <div class="mb-4">
            <a class="float-right" href="<c:url value='/'/>">Go to homepage</a>
        </div>
    </div>
</body>
</html>