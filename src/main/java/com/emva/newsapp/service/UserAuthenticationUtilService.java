package com.emva.newsapp.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
public class UserAuthenticationUtilService {
    public String getPrincipal() {
        String userName = null;

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null) {
            Object principal = auth.getPrincipal();
            
            if (principal != null) {
                if (principal instanceof UserDetails) {
                    userName = ((UserDetails) principal).getUsername();
                } else {
                    userName = principal.toString();
                }
            }
        }

        return userName;
    }

    public List<String> getAuthorities() {
        
        List<String> namedAuthorities = new ArrayList<String>();
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        if (auth != null) {
            Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();

            for (GrantedAuthority authority : authorities) {
                namedAuthorities.add(authority.getAuthority());
            }  
        }
        
        return namedAuthorities;
    }
}
