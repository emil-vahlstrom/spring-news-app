package com.emva.newsapp.service;

import java.util.List;
import java.util.Map;

import org.springframework.security.access.prepost.PreAuthorize;

import com.emva.newsapp.model.User;

public interface UserService {
    
    public User findUserById(Integer id);
    public User findUserBySSO(String sso);
    public List<User> findAllUsers();
    public List<User> findUsersByValue(Map<String, Object> equals, boolean isAscending, String orderBy);
    public void saveUser(User user);
//    @PreAuthorize("hasRole('ADMIN') OR #user.ssoId == authentication.name")
    public void updateUser(User user);
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteUser(Integer id);
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteBySSO(String ssoId);
    
}
