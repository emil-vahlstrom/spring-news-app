<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Write news</title>
    <jsp:include page="head-default.jsp" />
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="background faded"></div>
    <h1>Write News Page</h1>
    <c:if test="${isPreview}">
        <h2>Preview:</h2>
        <h3><c:out value="${news.headline}"/></h3>
        <h4>Lead:</h4>
        <em><c:out value="${news.lead}" escapeXml="false" /></em>
        <h4>Body:</h4>
        <c:out value="${news.body}" escapeXml="false"/>
        <hr>
    </c:if>
    
    <div class="mb-3 row no-gutters">
        <div class="side-filler col-xl-1 col-lg-1 d-none d-lg-block"></div>
        <div class="col-lg-6 col-md-8 main-content bg-grey-lighter">
            <div class="container-fluid">
                <c:url var="actionUrl" value="${actionUrn}"/><c:url var="previewUrl" value="${previewUrn}"/>
                <form:form action="${actionUrl}" modelAttribute="news" method="POST" autocomplete="off">
                    <input type="hidden" name="_method" value="${methodType}"/>
                    <form:hidden path="id" value="${news.id}"/>
                    <h3>News form:</h3>
                    
                    <div class="form-group">
                        <form:label path="headline">Headline: </form:label>
                        <form:input class="form-control" type="text" path="headline" value="${news.headline}" placeholder="enter headline here" /><br>
                    </div>
                    
                    <div class="form-group">
                        <form:label path="lead">Lead: </form:label>
                        <form:textarea class="form-control" path="lead" value="${news.lead}" placeholder="enter lead here" rows="3" /><br>
                    </div>
                    
                    <div class="form-group">
                        <form:label path="body">Body: </form:label><br>
                        <form:textarea class="form-control" path="body" value="${news.body}" placeholder="enter body here" rows="10" /><br>
                    </div>
                    
                    <button class="btn confirm-button" type="submit" name="submit" value="post">Post</button>
                    <button class="btn btn-success" type="submit" name="submit" value="preview">Preview</button>
                </form:form>
            </div>
        </div>
    </div>
</body>
</html>