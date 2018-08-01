<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="sec"
    uri="http://www.springframework.org/security/tags"%>

<c:url var="actionUrl" value='${actionUrn}' />
<form:form class="form-horizontal" action="${actionUrl}" modelAttribute="user" method="POST" autocomplete="off" >
    <input type="hidden" name="_method" value="${methodType}" />
    <form:hidden path="id" value="${id}" />

    <div class="form-row">
        <div class="form-group col-md-6">
            <form:label path="ssoId">Username</form:label>
            <form:input class="form-control" path="ssoId" type="text" placeholder="can be 7-15 charaters" required="required" />
        </div>
        
        <div class="form-group col-md-6">
            <form:label path="email">Email</form:label>
            <form:input class="form-control" path="email" type="text"  placeholder="example@example.com" required="required" />
        </div>
    </div>

    <div class="form-group">
        <form:label path="password">Password</form:label>
        <c:if test="${methodType == 'POST'}">
            <form:input class="form-control" path="password" placeholder="can be 7-15 charaters" required="required" />
        </c:if>
        <c:if test="${methodType == 'PUT'}">
            <form:input class="form-control"  placeholder="password(if not typed, previous password will be kept)" path="password" />
        </c:if>
        <small id="passwordHelp" class="form-text text-muted">
            This is a demo-site, as such security might be flawed. Don't write your regular password.
        </small>
    </div>
    
    <div class="form-row">
        <div class="form-group col-md-6">
            <form:label path="firstName">First Name</form:label>
            <form:input class="form-control" path="firstName" type="text"  placeholder="enter your first name" required="required" />
        </div>
        
        <div class="form-group col-md-6">
            <form:label path="lastName">Last Name</form:label>
            <form:input class="form-control" path="lastName" type="text"  placeholder="enter your last name" required="required" />
        </div>
    </div>
    
    <sec:authorize access="hasRole('ADMIN')">
        <div class="form-checkboxes">
            <form:label path="userProfiles">Roles: </form:label>
            <form:checkboxes class="" items="${roles}" path="userProfiles"
                itemLabel="type" itemValue="id" />
            <%--         <form:select path="userProfiles" items="${roles}" multiple="true" itemValue="id" itemLabel="type" /> --%>
        </div>
    </sec:authorize>
    
    <hr>
    <form:button class="btn confirm-button" type="submit">Submit</form:button> 
</form:form>