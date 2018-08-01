package com.emva.newsapp.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.emva.newsapp.model.UserProfile;

@Repository("userProfileDao")
public class UserProfileDaoImpl extends AbstractDao<Integer, UserProfile> implements UserProfileDao {
    @Override
    protected Class<UserProfile> getEntityClass() {
        return UserProfile.class;
    }
    
    public List<UserProfile> findAllUserProfiles() {
        return super.findAll();
    }
    
    public UserProfile findUserProfileByType(String type) {
        return super.uniqueResultOrNull("type", type);
    }
    
    public UserProfile findUserProfileById(Integer id) {
        return super.findById(id);
    }
}
