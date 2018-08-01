package com.emva.newsapp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emva.newsapp.dao.CommentDao;
import com.emva.newsapp.model.Comment;

@Service("commentService")
@Transactional
public class CommentServiceImpl implements CommentService {

    @Autowired
    @Qualifier(value = "commentDao")
    private CommentDao dao;
    
    @Override
    public Comment findCommentById(Integer id) {
        return dao.findCommentById(id);
    }
    
    @Override
    public Comment findCommentByIdFetchChildren(Integer id) {
        return dao.findCommentByIdFetchChildren(id);
    }

    @Override
    public List<Comment> findAllComments() {
        return dao.findAllComments();
    }

    @Override
    public void saveComment(Comment comment) {
        dao.saveComment(comment);
    }

    @Override
    public void updateComment(Comment comment) {
        dao.updateComment(comment);
    }

    @Override
    public void deleteComment(Integer id) {
        dao.deleteComment(id);
    }
    
    @Override
    public void deleteComment(Comment comment) {
        dao.deleteComment(comment);
    }

}
