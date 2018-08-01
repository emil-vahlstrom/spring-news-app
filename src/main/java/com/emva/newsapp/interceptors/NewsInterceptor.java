package com.emva.newsapp.interceptors;

import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

@Service
public class NewsInterceptor extends HandlerInterceptorAdapter {
    
    private static Logger LOG = LoggerFactory.getLogger(NewsInterceptor.class);

    @Autowired
    private Properties newsProperties;

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
            ModelAndView modelAndView) throws Exception {
        LOG.info("Running postHandle");
        
        String maxCommentsPerPage = newsProperties.getProperty("news.comments.max_amount", "10");
        String maxCommentDepth = newsProperties.getProperty("news.comments.max_depth", "5");
        
        if (modelAndView != null) {
            modelAndView.getModelMap().addAttribute("maxCommentDepth", maxCommentDepth);
            modelAndView.getModelMap().addAttribute("numCommentsLeft", maxCommentsPerPage);
        }
    }
    
    
}
