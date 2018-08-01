package com.emva.newsapp.service;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;

import com.emva.newsapp.model.Comment;

public interface CommentService {
    public Comment findCommentById(Integer id);
    public Comment findCommentByIdFetchChildren(Integer id);
    public List<Comment> findAllComments();
    //isFullyAuthenticated() is good to avoid SpelEvaluationException if #comment.user is null
    @PreAuthorize("isFullyAuthenticated() AND #comment.user.ssoId == authentication.name")
    public void saveComment(Comment comment);
    @PreAuthorize("isFullyAuthenticated() AND #comment.user.ssoId == authentication.name")
    public void updateComment(Comment comment);
    @PreAuthorize("hasRole('PUBLISHER')")
    public void deleteComment(Integer id);
    @PreAuthorize("hasRole('PUBLISHER')")
    public void deleteComment(Comment comment);
}
