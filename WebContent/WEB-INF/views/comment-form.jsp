<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Write a comment</title>
    <jsp:include page="head-default.jsp" />
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="background"></div>
    <div class="centered-card">
        <c:choose>
            <c:when test="${(not empty replyId) and (replyId gt 0)}">
                <h2>Write a reply</h2>
                <span>Comment written by <strong>${commentToReply.user.ssoId}</strong>:</span><br>
                <div class="lighter-background">${commentToReply.text}</div>
            </c:when>
            <c:when test="${fn:toUpperCase(methodType) eq 'PUT'}">
                <h2>Edit a comment</h2>
            </c:when>
            <c:otherwise>
                <h2>Write new comment</h2>
            </c:otherwise>
        </c:choose>
        <hr>
        <c:url var="actionUrl" value="${actionUrn}" />
        <form:form action="${actionUrl}" modelAttribute="comment" method="POST" autocomplete="off">
            <input type="hidden" name="_method" value="${methodType}" />
            <form:hidden path="replyId" value="${replyId}"/>
            <form:hidden path="id" value="${comment.id}"/>

            <div class="form-group">
                <form:label path="text"><strong>Comment text: </strong></form:label>
                <form:textarea class="form-control" path="text" rows="3" autofocus="autofocus" required="required"/>
            </div>
            <div class="form-group">
                <input class="btn confirm-button" type="submit" value="submit"/>
            </div>
            <a href="<c:url value='/news/${newsId}'/>">Go back to article</a>
        </form:form>
    </div>
</body>
</html>