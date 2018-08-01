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
    <title>Comment</title>
    <jsp:include page="head-default.jsp" />
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="background faded"></div>
    
    <div class="row no-gutters">
        <div class="side-filler col-xl-2 col-lg-1 d-none d-lg-block"></div>
        
        <div class="col-xl-5 col-lg-6 col-md-8 main-content news-body p-clear-both p-text-justify">
            <div class="container-fluid">
                <h1 class="news-header">${news.headline}</h1>
        
                <sec:authorize access="isFullyAuthenticated()">
                    <sec:authentication var="username" scope="request" property="principal.username" />
                </sec:authorize>
                <sec:authorize access="!isFullyAuthenticated()">
                    <c:set var="username" scope="request" value="none" />
                </sec:authorize>
                            
                <h3>Comments:</h3>
                <c:set var="comments" value="${comment}" scope="request"/>
                <c:set var="numCommentsLeft" value="${numCommentsLeft}" scope="request"/>
                <div class="comment-field">
                    <jsp:include page="node.jsp"/>
                    <c:if test="${not empty nextCommentsOffset}">
                        <hr class="faded my-3">
                        <ul class="comment-list"><li class="load-comments">
                            <a href="<c:url value='/news/${news.id}/comments/${comment[0].id}?commentsOffset=${nextCommentsOffset}'/>">Load more comments on next page...</a>
                        </li></ul>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="side col-xl-2 col-lg-3 col-md-4 d-none d-md-block">
            <div class="side-item-group">
                <span class="font-weight-light">Ad content:</span>
                <img class="side-item" src="http://via.placeholder.com/350x150">
            </div>
            
            <div class="side-item-group">
                <span class="font-weight-light">Ad content:</span>
                <img class="side-item" src="http://via.placeholder.com/350x700">
            </div>
            
            <div class="side-item-group">
                <span class="font-weight-light">Ad content:</span>
                <img class="side-item" src="http://via.placeholder.com/350x300">
            </div>
            
            <div class="side-item-group">
                <span class="font-weight-light">Ad content:</span>
                <img class="side-item" src="http://via.placeholder.com/250x200">
            </div>
        </div>
        <div class="side-filler col-xl-3 col-lg-2 d-none d-lg-block"></div>
    </div>
</body>
</html>