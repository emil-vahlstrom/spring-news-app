package com.emva.newsapp.model;

public enum UserProfileType {
    USER("USER"),
    DBA("DBA"),
    ADMIN("ADMIN"),
    PUBLISHER("PUBLISHER");

    private String userProfileType;
    
    private UserProfileType(String userProfileType) {
        this.userProfileType = userProfileType;
    }
    
    public String getUserProfileType() {
        return userProfileType;
    }
}
