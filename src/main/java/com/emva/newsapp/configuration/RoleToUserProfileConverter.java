package com.emva.newsapp.configuration;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import com.emva.newsapp.model.UserProfile;
import com.emva.newsapp.service.UserProfileService;

@Component
public class RoleToUserProfileConverter implements Converter<Object, UserProfile>{
    
    static final Logger logger = LoggerFactory.getLogger(RoleToUserProfileConverter.class);
    
    @Autowired
    UserProfileService userProfileService;

    @Override
    public UserProfile convert(Object element) {
        Integer id = Integer.parseInt((String)element);
        UserProfile profile = userProfileService.findUserProfileById(id);
        logger.info("Profile : {}", profile);
        return profile;
    }
    
    
//    public UserProfile convert(Object element) {
//        String type = (String)element;
//        UserProfile profile = userProfileService.findUserProfileByType(type);
//        System.out.println("Profile ... : " + profile);
//        return profile;
//    }
    
}
