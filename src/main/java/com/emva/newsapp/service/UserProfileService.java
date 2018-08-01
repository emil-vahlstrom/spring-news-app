package com.emva.newsapp.service;

import java.util.List;

import com.emva.newsapp.model.UserProfile;

public interface UserProfileService {
    public List<UserProfile> findAllUserProfiles();
    public UserProfile findUserProfileByType(String type);
    public UserProfile findUserProfileById(Integer id);
}
