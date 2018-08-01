package com.emva.newsapp.dao;

import java.util.List;

import com.emva.newsapp.model.UserProfile;

public interface UserProfileDao {
    public List<UserProfile> findAllUserProfiles();
    public UserProfile findUserProfileByType(String type);
    public UserProfile findUserProfileById(Integer id);
}
