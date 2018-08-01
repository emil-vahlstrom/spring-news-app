package com.emva.newsapp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emva.newsapp.dao.UserProfileDao;
import com.emva.newsapp.model.UserProfile;

@Service("userProfileService")
@Transactional
public class UserProfileServiceImpl implements UserProfileService {
    
    @Autowired
    private UserProfileDao dao;
    
    public List<UserProfile> findAllUserProfiles() { 
        return dao.findAllUserProfiles(); 
    }
    
    public UserProfile findUserProfileByType(String type) {
        return dao.findUserProfileByType(type);
    }
    
    public UserProfile findUserProfileById(Integer id) {
        return dao.findUserProfileById(id);
    }
}
