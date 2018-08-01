package com.emva.newsapp.dao;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Order;
import javax.persistence.criteria.Root;

import org.hibernate.Hibernate;
import org.springframework.stereotype.Repository;

import com.emva.newsapp.model.Comment;
import com.emva.newsapp.model.News;

@Repository("newsDao")
public class NewsDaoImpl extends AbstractDao<Integer, News> implements NewsDao {

    // @Autowired
    // private SessionFactory sessionFactory;

    protected Class<News> getEntityClass() {
        return News.class;
    }

    @Override
    public News findNewsById(Integer id) {
        News news = findById(id);
        if (news != null) {
            //not needed, body is property, so fetchtype=lazy is ignored by hibernate
            //and eagerly loaded anyway
            Hibernate.initialize(news.getBody());
            Hibernate.initialize(news.getComments());
            
            initComments(news.getComments());
        }
        
        return news;
    }

    public List<News> findNews(int limit, int offset) {
        // select * from news order by created desc, id desc LIMIT 5 offset 5;
        // means start from record 6
        // performance problems, also try this
        // Hold the last id of a set of data(30) (e.g. lastId = 530)
        // Add the condition WHERE id > lastId limit 0,30
        
        CriteriaBuilder builder = getEntityManager().getCriteriaBuilder();
        CriteriaQuery<News> criteriaQuery = builder.createQuery(News.class);
        Root<News> root = criteriaQuery.from(News.class);
        criteriaQuery.select(root);
        criteriaQuery.orderBy(new Order[] { builder.desc(root.get("id"))});
        
        List<News> news = getEntityManager().createQuery(criteriaQuery).setFirstResult(offset).setMaxResults(limit).getResultList();
        
        for (News n : news) {
//            Hibernate.initialize(n.getAuthor().getUserProfiles());
            Hibernate.initialize(n.getBody());
            Hibernate.initialize(n.getComments());
            Hibernate.initialize(n.getNewsImageHeads());
            initComments(n.getComments());
        }
        
        return news;
    }
    
    /* TODO: test, also combine with findNews to make DRY */
    public List<News> findNewsSummary(int limit, int offset) {
        CriteriaBuilder builder = getEntityManager().getCriteriaBuilder();
        CriteriaQuery<News> criteriaQuery = builder.createQuery(News.class);
        Root<News> root = criteriaQuery.from(News.class);
        criteriaQuery.select(root);
        criteriaQuery.orderBy(new Order[] { builder.desc(root.get("id"))});
        
        List<News> news = getEntityManager().createQuery(criteriaQuery).setFirstResult(offset).setMaxResults(limit).getResultList();
        return news;
    }
    
    /**
     * Fetches all news from db and only initializes id, headline, lead, created, modified.
     */
    @Override
    public List<News> findAllNewsShortSummary() {
        List<News> allNews = findAll();
        return allNews;
    }
    
    /**
     * Find all news with lazy fetching, order by created desc, id desc
     */
    @Override
    public List<News> findAll() {
        CriteriaBuilder builder = getEntityManager().getCriteriaBuilder();
        CriteriaQuery<News> criteriaQuery = builder.createQuery(News.class);
        Root<News> root = criteriaQuery.from(News.class);
        criteriaQuery.select(root);
        criteriaQuery.orderBy(new Order[] {builder.desc(root.get("created")), builder.desc(root.get("id"))});
        List<News> allNews = getEntityManager().createQuery(criteriaQuery).getResultList();
        return allNews;
    }
    
    /**
     * Fully fetches all news with comments and users associated to comments
     */
    @Override
    public List<News> findAllNewsFullWithComments() {
        List<News> allNews = findAll();
        if (allNews != null) {
            for (News news : allNews) {
                Hibernate.initialize(news.getComments());
                // not necessary, since news.body is eagerly loaded by
                // hibernate, even though fetch is set to lazy
                // hibernate ignores fetch attributes on properties
                Hibernate.initialize(news.getBody()); 
                initComments(news.getComments());
            }
        }
        return allNews;
    }

    // TODO NewsDaoImpl and CommentDaoImpl have the same method called initComments.
    // Make into static method in util class?
//    public void initComments(List<Comment> comments) {
//        if (comments.size() > 0) {
//            for (Comment comment : comments) {
//                Hibernate.initialize(comment.getChildren());
//                Hibernate.initialize(comment.getUser());
//                if (comment.getChildren().size() > 0) {
//                    initComments(comment.getChildren());
//                }
//            }
//        }
//    }
    
    public void initComments(List<Comment> commentsToInitialize) {
        for (Comment comment : commentsToInitialize) {
            
            List<Comment> comments = comment.getAllComments();
            for (Comment c : comments) {
                Hibernate.initialize(c);
                Hibernate.initialize(c.getUser());
            }
        }
    }

    @Override
    public void saveNews(News news) {
        persist(news);
    }

    @Override
    public void updateNews(News news) {
        merge(news);
        // getSession().update(news);
    }

    @Override
    public void deleteNews(Integer id) {
        delete(id);
    }

    @Override
    public void deleteNews(News news) {
        delete(news);
    }

}
