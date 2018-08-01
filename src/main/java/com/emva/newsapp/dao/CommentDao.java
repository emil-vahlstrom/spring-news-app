package com.emva.newsapp.dao;

import java.util.List;

import com.emva.newsapp.model.Comment;

public interface CommentDao {
    
    public Comment findCommentById(Integer id);
    public Comment findCommentByIdFetchChildren(Integer id);
    public List<Comment> findAllComments();
    public void saveComment(Comment comment);
    public void updateComment(Comment comment);
    public void deleteComment(Integer id);
    public void deleteComment(Comment comment);
}
