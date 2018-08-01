package com.emva.newsapp.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emva.newsapp.dao.UserDao;
import com.emva.newsapp.model.User;

@Service("userService")
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao dao;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Override
    public User findUserById(Integer id) {
        return dao.findUserById(id);
    }

    @Override
    public User findUserBySSO(String sso) {
        return dao.findUserBySSO(sso);
    }

    @Override
    public List<User> findAllUsers() {
        return dao.findAllUsers();
    }

    @Override
    public List<User> findUsersByValue(Map<String, Object> equals, boolean isAscending, String orderBy) {
        return dao.findUsersByValue(equals, isAscending, orderBy);
    }

    @Override
    public void saveUser(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        dao.saveUser(user);
    }

    @Override
    public void updateUser(User user) {
        User entity = dao.findUserById(user.getId());
        
        if (entity != null) {
            entity.setSsoId(user.getSsoId());
            if (!user.getPassword().equals(entity.getPassword())) {
                entity.setPassword(passwordEncoder.encode(user.getPassword()));
            }
            entity.setFirstName(user.getFirstName());
            entity.setLastName(user.getLastName());
            entity.setEmail(user.getEmail());
            if (user.getUserProfiles() != null) {
                entity.setUserProfiles(user.getUserProfiles());
            }
        }
    }

    @Override
    public void deleteUser(Integer id) {
        dao.deleteUser(id);
    }

    @Override
    public void deleteBySSO(String ssoId) {
        dao.deleteBySSO(ssoId);
    }

}
