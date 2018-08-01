package com.emva.newsapp.dao;

import java.util.List;

import org.hibernate.Hibernate;
import org.springframework.stereotype.Repository;

import com.emva.newsapp.model.Comment;

@Repository("commentDao")
public class CommentDaoImpl extends AbstractDao<Integer, Comment> implements CommentDao {

    @Override
    protected Class<Comment> getEntityClass() {
        return Comment.class;
    }

    @Override
    public Comment findCommentById(Integer id) {
        Comment comment = findById(id);
        if (comment != null) {
            /* user is set as lazy fetched even though using @ManyToOne */
            Hibernate.initialize(comment.getUser());
        }
        return findById(id);
    }
    
    @Override
    public Comment findCommentByIdFetchChildren(Integer id) {
        Comment comment = findById(id);
  
        if (comment != null) {
            List<Comment> comments = comment.getAllComments();
            for (Comment c : comments) {
                Hibernate.initialize(c);
                Hibernate.initialize(c.getUser());
            }
        }
        
        return comment;
    }

    @Override
    public List<Comment> findAllComments() {
        return findAll();
    }

    @Override
    public void saveComment(Comment comment) {
        persist(comment);
    }

    @Override
    public void updateComment(Comment comment) {
        merge(comment);
    }

    @Override
    public void deleteComment(Integer id) {
        delete(id);
    }

    @Override
    public void deleteComment(Comment comment) {
        delete(comment);
    }

}
