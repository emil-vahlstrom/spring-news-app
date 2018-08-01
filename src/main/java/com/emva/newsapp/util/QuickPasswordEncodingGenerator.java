package com.emva.newsapp.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class QuickPasswordEncodingGenerator {
    
    public static void main(String[] args) {
        String password = "abc125";
        String password2 = "abc123";
        BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        System.out.println(passwordEncoder.encode(password));
        System.out.println(passwordEncoder.encode(password2));
    }
}
