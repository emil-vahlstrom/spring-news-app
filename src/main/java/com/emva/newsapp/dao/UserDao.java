package com.emva.newsapp.dao;

import java.util.List;
import java.util.Map;

import com.emva.newsapp.model.User;

public interface UserDao {
    
    public User findUserById(Integer id);
    public User findUserBySSO(String sso);
    public List<User> findAllUsers();
    public List<User> findUsersByValue(Map<String, Object> equals, boolean isAscending, String orderBy);
    public void saveUser(User user);
    public void updateUser(User user);
    public void deleteUser(Integer id);
    public void deleteBySSO(String ssoId);
}
