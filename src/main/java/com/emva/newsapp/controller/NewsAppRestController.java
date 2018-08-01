package com.emva.newsapp.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.emva.newsapp.model.News;
import com.emva.newsapp.service.NewsService;
import com.emva.newsapp.service.UserAuthenticationUtilService;

@Controller
public class NewsAppRestController {
    
    private Logger LOG = LoggerFactory.getLogger(NewsAppRestController.class);
    
    @Autowired
    private NewsService newsService;
    
    @Autowired
    private UserAuthenticationUtilService userAuthenticationUtilService;

    /* ==== REST Path ==== */
    @RequestMapping(value = "/users/authenticated", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<Map<String, String>> getUser() {
        LOG.info("GET request sent to: '/users/authenticated'");
        String username = userAuthenticationUtilService.getPrincipal();
        
        Map<String, String> user = new HashMap<String, String>();
        user.put("username", username);
        
        return new ResponseEntity<Map<String, String>>(user, HttpStatus.OK);
    }
    
    /* Todo: give better path mapping */
    @RequestMapping(value = "/news", produces = MediaType.APPLICATION_JSON_VALUE, consumes = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<News>> getNews(@RequestParam(name = "page", defaultValue = "0") Integer pageNo) {
        
        final Integer NEWS_SIZE_LIMIT = 5;
        
        LOG.info("GET request sent to: '/news'");
        LOG.info("pageNo: {}", pageNo);
        Integer offset = pageNo * NEWS_SIZE_LIMIT;
        
        List<News> news = newsService.findNews(NEWS_SIZE_LIMIT, offset);
        
//        LOG.info("Printing news:");
//        for (News n : news) {
//            LOG.info(n.toString());
//        }
        
        if (news == null || news.size() == 0) {
            LOG.info((news == null ? "News is NULL" : "News is empty"));
            HttpStatus statusCode = news == null ? HttpStatus.NOT_FOUND : HttpStatus.NO_CONTENT;
            return new ResponseEntity<List<News>>(news, statusCode);
        }
        
        return new ResponseEntity<List<News>>(news, HttpStatus.OK);
    }
}
