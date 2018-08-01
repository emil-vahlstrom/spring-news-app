<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Admin Page</title>
    <jsp:include page="head-default.jsp" />
</head>
</head>
<body>
<c:if test="${status != null}">
    <div class="alert alert-${status}">${resultsMessage}</div>
    <br>
</c:if>
<a href="<c:url value='/'/>">Go Home</a>
<p>
welcome to admin page<br>
here you can:
<ul>
    <li>add user</li>
    <li>edit user roles and credentials</li>
    <li>activate/inactivate user account</li>
</ul>
</p>

<hr>
<c:set var="actionUrn" value="/users" scope="request" />
<c:set var="methodType" value="POST" scope="request"/>
<div class="row">
    <div class="col-lg-6 col-md-10">
        <div class="container-fluid">
        <h2>Create/update a user</h2>
        <jsp:include page="user-form.jsp"/>
        </div>
    </div>
</div>
<hr>
<h2>All Users</h2>
<table>
    <tr>
        <th>Id</th>
        <th>Username</th>
<!--         <th>Password</th> -->
        <th>FirstName</th>
        <th>LastName</th>
        <th>Email</th>
        <th>Roles</th>
        <th>Actions</th>
    </tr>
    <c:forEach var="user" items="${allUsers}"><tr>
        <td>${user.id}</td>
        <td>${user.ssoId}</td>
<%--         <td>${user.password}</td> --%>
        <td>${user.firstName}</td>
        <td>${user.lastName}</td>
        <td>${user.email}</td>
        <td>
            <c:forEach var="role" items="${user.userProfiles}" varStatus="status">
                <c:out value="${role.type}"/><c:if test="${!status.last}">, </c:if>
            </c:forEach>
        </td><c:url value="/users/${user.id}" var="deleteUserAction" />
        <td><a href="<c:url value='/users/${user.id}/edit'/>">Edit</a> | 
        <form:form action="${deleteUserAction}" method="POST" style="display: inline">
            <input type="hidden" name="_method" VALUE="DELETE" />
            <button type="submit">Delete</button>
        </form:form>
    </tr></c:forEach>
</table>
</body>
</html>