package com.emva.newsapp.configuration;

import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;

@Configuration
@PropertySource(value = "classpath:application.properties")
public class NewsConfig {
    
    @Autowired
    private Environment environment;
    
    @Bean(name = "newsProperties")
    public Properties newsProperties() {
        Properties properties = new Properties();
        properties.put("news.comments.max_amount", environment.getRequiredProperty("news.comments.max_amount"));
        properties.put("news.comments.max_depth", environment.getRequiredProperty("news.comments.max_depth"));
        return properties;
    }
}
