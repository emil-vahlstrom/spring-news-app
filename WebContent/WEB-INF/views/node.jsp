<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<ul class="comment-list">
    <c:set var="isChildrenAllowed" scope="page"
        value="${(fn:length(comments) ge numCommentsLeft) ? 'false' : 'true'}" />
    <c:set var="localCommentsLeft" scope="page"
        value="${numCommentsLeft}" />
    <c:set var="numCommentsLeft" scope="request"
        value="${((numCommentsLeft - fn:length(comments)) lt 0) ? 0 : (numCommentsLeft - fn:length(comments))}" />
    <c:forEach var="comment" items="${comments}" varStatus="status">
        <c:if test="${localCommentsLeft gt 0}">
            <c:choose>
                <c:when test="${comment.isActive()}">
                    <c:set var="utc" value="UTC" />
                    <c:set var="dateFormat"
                        value="yyyy-MM-dd HH:mm ('UTC'Z)" />
                    <fmt:formatDate value="${comment.created}"
                        pattern="${dateFormat}" var="dateString" />
                    <c:set var="commentText"
                        value="<span><strong>${comment.user.ssoId}</strong>&nbsp;<small>at ${dateString}</small></span>
                        <div class=&quot;ml-3&quot;>${comment.text}</div>" />
                </c:when>
                <c:otherwise>
                    <c:set var="commentText"
                        value="<em>Comment was deleted</em>" />
                </c:otherwise>
            </c:choose>
            <li><c:out value="${commentText}" escapeXml="false" />
                <c:set var="contextPath" value="${pageContext.request.contextPath}" /> 
                <c:if test="${comment.isActive()}">
                    <div class="ml-3">
                        <a class="btn btn-outline-primary btn-sm"
                            href="<c:url value='/news/${news.id}/comments/${comment.id}/reply'/>">Reply</a>
                        <c:if test="${username eq comment.user.ssoId}">
                            <a class="btn btn-outline-dark btn-sm"
                                href="<c:url value='/news/${news.id}/comments/${comment.id}/edit'/>">Edit</a>
                            <c:url var="deleteAction"
                                value="/news/${news.id}/comments/${comment.id}" />
                            <form:form action="${deleteAction}"
                                style="display: inline;">
                                <input type="hidden" name="_method"
                                    value="DELETE" />
                                <button
                                    class="btn btn-sm btn-outline-danger"
                                    type="submit">Delete</button>
                            </form:form>
                        </c:if>
                    </div>
                </c:if></li>
            <c:set var="localCommentsLeft"
                value="${localCommentsLeft - 1}" scope="page" />
            <c:if test="${empty comment.replyId}">
                <c:set var="depth" value="1" scope="request" />
            </c:if>
            <c:if test="${comment.children.size() > 0}">
                <c:set var="comments" value="${comment.children}"
                    scope="request" />
                <!-- if maxCommentDepth == 1 then replies can never be read. -->
                <c:if test="${isChildrenAllowed eq 'false' or depth ge maxCommentDepth}">
                    <li class="load-comments">
                        <a href="<c:url value='/news/${news.id}/comments/${comment.id}'/>">>> Load more replies...</a>
                     </li>
                </c:if>
                <c:if test="${isChildrenAllowed eq 'true' and depth lt maxCommentDepth}">
                    <c:set var="depth" value="${depth+1}"
                        scope="request" />
                    <jsp:include page="node.jsp" />
                    <c:set var="depth" value="${depth-1}"
                        scope="request" />
                </c:if>
            </c:if>
            <c:if test="${localCommentsLeft eq 0 and not status.last}">
                <c:set var="loadMore" value="true" scope="page" />
                <c:set var="commentParentId" value="${comment.parent.id}" scope="page" />
            </c:if>
        </c:if>
    </c:forEach>
</ul>
<c:if test="${loadMore != null}">
    <li class="load-comments">
        <a href="<c:url value='/news/${news.id}/comments/${commentParentId}'/>">> Load more replies...</a>
    </li>
</c:if>