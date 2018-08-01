<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Welcome</title>
</head>
<body>
<c:out value="${test}"/> 
<br>
${greeting}
<br>
<a href="<c:url value='/thymeleaf' />">Thymeleaf</a>
<br>
<br>
Hello ${user}
<br>
<br>
<a href="<c:url value='/admin'/>">Admin Page</a>
<br>
<br>
<sec:authorize access="isFullyAuthenticated()">
    <strong>Logged in as: <sec:authentication property="principal.username" /> </strong><a href="<c:url value='/logout' />">Logout</a>
</sec:authorize>
<sec:authorize access="!isFullyAuthenticated()">
    <a href="<c:url value='/login' />">Login</a>
</sec:authorize>
<br>
<br>
<sec:authorize access="hasRole('PUBLISHER')">
    <a href="<c:url value='/news/new' />">Write News</a>
</sec:authorize>
<h2>List of news headlines(without comments or body)</h2><c:set var="dateFormat" value="yyyy-MM-dd"/>
<table>
    <tr>
        <th>Id</th>
        <th>Headline</th>
        <th>Lead</th>
        <th>Author</th>
        <th>Created</th>
        <th>Modified</th>
    </tr>
    <c:forEach var="news" items="${allNews}">
        <tr>
            <td><c:out value="${news.id}"/></td>
            <td>${news.headline}</td>
            <td>${news.lead}</td>
            <td>${news.author.ssoId}</td>
            <td><fmt:formatDate value="${news.created}" pattern="${dateFormat}"/></td>
            <td><fmt:formatDate value="${news.modified}" type="date"/></td>
        </tr>
        <tr>
            <td colspan="6">
                <a href="<c:url value='/news/${news.id}' />">Read more</a> | 
                <a href="<c:url value='/news/${news.id}/edit' />">Edit</a> | 
                <c:url var="deleteNewsAction" value='/news/${news.id}' />
                <form:form style="display: inline" method="POST" action="${deleteNewsAction}">
                    <input type="hidden" name="_method" value="DELETE"/>
                    <button type="submit">Delete</button>
                </form:form>
            </td>
        </tr>
    </c:forEach>
</table>
<hr>
<h2>List of news(full)</h2><c:set var="dateFormat" value="yyyy-MM-dd"/>
<table>
    <tr>
        <th>Id</th>
        <th>Headline</th>
        <th>Lead</th>
        <th>Body</th>
        <th>Author</th>
        <th>Created</th>
        <th>Modified</th>
    </tr>
    <c:forEach var="news" items="${allNews}">
        <tr>
            <td><c:out value="${news.id}"/></td>
            <td>${news.headline}</td>
            <td>${news.lead}</td>
            <td><c:out value="${news.body}" escapeXml="false"/></td>
            <td>${news.author.ssoId}</td>
            <td><fmt:formatDate value="${news.created}" pattern="${dateFormat}"/></td>
            <td><fmt:formatDate value="${news.modified}" type="date"/></td>
        </tr>
        <tr>
            <td colspan="4">
                <h4>Comments</h4>
                <c:set var="comments" value="${news.comments}" scope="request"/>
                <c:set var="news" value="${news}" scope="request"/>
                <jsp:include page="node.jsp"/>
            </td>
        </tr>
    </c:forEach>
</table>
<hr>
<h2>Comments</h2>
<table>
    <tr>
        <th>Id</th>
        <th>Reply Id</th>
        <th>Text</th>
        <th>Created</th>
        <th>Modified</th>
    </tr>
    <c:forEach var="comment" items="${allComments}">
        <tr>
            <td><c:out value="${comment.id}"/></td>
            <td><c:out value="${comment.replyId}"/></td>
            <td><c:out value="${comment.text}"/></td>
            <td><fmt:formatDate value="${comment.created}" pattern="${dateFormat}"/></td>
            <td><fmt:formatDate value="${comment.modified}" pattern="${dateFormat}"/></td>
        </tr>
    </c:forEach>
</table>
<hr>
<h2>Images</h2>
<table>
    <tr>
        <th>Id</th>
        <th>Uri</th>
    </tr>
    <tr>
        <c:forEach var="image" items="${allImages}">
            <tr>
                <td>${image.id}</td>
                <td><c:out value="${image.uri}"/></td>
            </tr>
        </c:forEach>
    </tr>
</table>
<hr>
<h2>Users</h2>
<table>
    <tr>
        <th>Id</th>
        <th>Sso</th>
        <th>Password</th>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>Roles</th>
    </tr>
    <c:forEach var="user" items="${allUsers}">
        <tr>
            <td><c:out value="${user.id}"/></td>
            <td><c:out value="${user.ssoId}"/></td>
            <td><c:out value="${user.password}"/></td>
            <td><c:out value="${user.firstName}"/></td>
            <td><c:out value="${user.lastName}"/></td>
            <td><c:out value="${user.email}"/></td>
            <td>
                <c:forEach var="role" items="${user.userProfiles}" varStatus="status">
                    <c:out value="${role.type}"/><c:if test="${!status.last}">, </c:if>
                </c:forEach>
            </td>
        </tr>
    </c:forEach>
</table>

<hr>

</body>
</html>