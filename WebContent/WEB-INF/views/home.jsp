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
    <script type="text/javascript">
        <!-- settings variables for script -->
        var path = "${pageContext.request.contextPath}";
        var csrfParameterName = "${_csrf.parameterName}";
        var csrfToken = "${_csrf.token}";
    </script>
    <jsp:include page="head-default.jsp" />
    <script src="<c:url value='/js/home.js'/>" type="text/javascript"></script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="background faded"></div>
    
    <div class="row no-gutters">
        <div class="side-filler col-xl-2 col-lg-1 d-none d-lg-block"></div>
        
        <div class="col-xl-5 col-lg-6 col-md-8 main-content">
            <div class="container-fluid">
                <hr class="thick">
                <c:forEach var="news" items="${allNews}">
    
                    <div class="news-item row no-gutters">
                        <c:forEach var="head" items="${news.getNewsImageHeads()}" varStatus="status">
                            <c:if test="${!head.getThumbnail()}"> <!-- col-sm-${head.size} col-${head.size > 6 ? 12 : 6 } --><%-- d-none d-md-block --%>
                                <div class="inset-shadow p-sm-2px col-${head.size} ${status.index > 0 ? 'pl-2px' : ''}">
                                    <c:url var="img" value="${head.pk.image.uri}"/>
                                    <img class="news-head-image" src="${img}" alt="cover image">
                                </div>
                            </c:if>
                            
                            <c:if test="${head.getThumbnail()}">
                                <c:set var="thumb" value="${head.pk.image.uri}" />
                            </c:if>
                        </c:forEach>
    
                        <div class="col-12 news-lead linear-gradient-bottom">
                            <h2>${news.headline}</h2>
                            <div>                                                 <!-- float-sm-right -->
                                <c:if test="${thumb != null}"><div class="inset-shadow float-right thumb-image position-relative">
                                    <img class="w-100 h-100" src="${thumb}" alt="thumbnail">
                                </div><c:remove var="thumb"/></c:if>
                                ${news.lead}&nbsp;
                            </div>
                            <c:set var="dateFormat" value="yyyy-MM-dd" />
                            <div>
                                <fmt:formatDate value="${news.created}" pattern="${dateFormat}"/>&nbsp;
                                <a href="<c:url value='/news/${news.id}' />">Read more</a>
                            </div>
                
                            <!-- MAKE SURE PRINCIPAL USERNAME IS EVALUATED TO, IF PUBLISHER -->
                            <sec:authorize access="hasRole('PUBLISHER')">
                                <c:if test="${username eq news.author.ssoId}">
                                    &nbsp;|&nbsp;<a href="<c:url value='/news/${news.id}/edit' />">Edit</a>&nbsp;|&nbsp;
                                    <c:url var="deleteNewsAction" value='/news/${news.id}' />
                                    <form:form style="display: inline" method="POST" action="${deleteNewsAction}">
                                        <input type="hidden" name="_method" value="DELETE"/>
                                        <button type="submit">Delete</button>
                                    </form:form>
                                </c:if>
                            </sec:authorize>
                        </div>
                    </div>
                    <hr class="thick">
                </c:forEach>
                
                <div id="moreNews">
                    <!-- insert news here, remember first news are preloaded when page is rendered -->
                </div>
                <br>
                <button class="btn btn-outline-primary" id="loadNewsButton">Load more news</button>  
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