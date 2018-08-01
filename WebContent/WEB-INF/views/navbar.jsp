<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<nav class="navbar navbar-dark bg-dark navbar-expand-md sticky-top">
    <a class="navbar-brand mb-0 h1" href="<c:url value='/#'/>"><i class="far fa-newspaper fa-lg">&nbsp;</i>SpringNewsApp</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavDropdown">
        <ul class="navbar-nav mr-auto">
            <sec:authorize access="hasRole('ADMIN')">
                <li class="nav-item active">
                    <a class="nav-link" href="<c:url value='/admin'/>">Admin Page</a>
                </li>
            </sec:authorize>
            <sec:authorize access="hasRole('PUBLISHER')">
                <li class="nav-item active">
                    <a class="nav-link" href="<c:url value='/news/new' />">Write News</a>
                </li>
            </sec:authorize>
            <li class="nav-item active">
                <sec:authorize access="isFullyAuthenticated()">
                    <sec:authentication var="username" property="principal.username" />
                    <a class="nav-link" href="<c:url value='/logout' />">Logout</a>
                </sec:authorize>
                <sec:authorize access="!isFullyAuthenticated()">
                    <a class="nav-link" href="<c:url value='/login' />">Login</a>
                    <c:set var="username" scope="request" value="none" />
                </sec:authorize>
            </li>
            <li class="nav-item">
                <sec:authorize access="!isFullyAuthenticated()">
                    <a class="nav-link" href="<c:url value='/users/new'/>">Create user</a>
                </sec:authorize>
            </li>
        </ul>
        <span class="navbar-text text-white"><strong>Logged in as: </strong>${username}</span>
    </div>
</nav>