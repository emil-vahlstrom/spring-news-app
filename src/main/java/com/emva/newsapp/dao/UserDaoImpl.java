package com.emva.newsapp.dao;

import java.util.List;
import java.util.Map;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.hibernate.Hibernate;
import org.springframework.stereotype.Repository;

import com.emva.newsapp.model.User;

@Repository("userDao")
public class UserDaoImpl extends AbstractDao<Integer, User> implements UserDao {

    @Override
    protected Class<User> getEntityClass() {
        return User.class;
    }
    
    @Override
    public User findUserById(Integer id) {
        User user = findById(id);
        if (user != null) {
            Hibernate.initialize(user.getUserProfiles());
            //probably not neccessary to init getNews in a typical use-case, it's just here for testing purposes
            Hibernate.initialize(user.getNews()); 
        }
        return user;
    }

    @Override
    public User findUserBySSO(String sso) {
        User user = null;
        user = uniqueResultOrNull("ssoId", sso);
        if (user != null) {
            Hibernate.initialize(user.getUserProfiles());
        }
        return user;
    }

    @Override
    public List<User> findAllUsers() {
//        Session session = getSession();
//        CriteriaBuilder builder = session.getCriteriaBuilder();
        CriteriaBuilder builder = getEntityManager().getCriteriaBuilder();
        CriteriaQuery<User> criteriaQuery = builder.createQuery(User.class);
        Root<User> root = criteriaQuery.from(User.class);
        
        criteriaQuery.select(root);
        criteriaQuery.orderBy(builder.asc(root.get("firstName")));
        criteriaQuery.distinct(true);
        List<User> users = getEntityManager().createQuery(criteriaQuery).getResultList();
        
        for (User user : users) {
            Hibernate.initialize(user.getUserProfiles());
        }
        
        return users;
    } 

    @Override
    public List<User> findUsersByValue(Map<String, Object> equals, boolean isAscending, String orderBy) {
        return findByValue(equals, isAscending, orderBy);
    }

    @Override
    public void saveUser(User user) {
        persist(user);
    }

    @Override
    public void updateUser(User user) {
        merge(user);
    }

    @Override
    public void deleteUser(Integer id) {
        delete(id);
    }

    @Override
    public void deleteBySSO(String ssoId) {
        User user = uniqueResultOrNull("ssoId", ssoId);
        if (user != null) {
            delete(user);
        }
    }
    
}
