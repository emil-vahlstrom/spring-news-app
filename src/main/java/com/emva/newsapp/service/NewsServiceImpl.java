package com.emva.newsapp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emva.newsapp.dao.NewsDao;
import com.emva.newsapp.model.News;

@Service("newsService")
@Transactional
public class NewsServiceImpl implements NewsService {

    @Autowired
    private NewsDao dao;
    
    @Override
    public News findNewsById(Integer id) {
        return dao.findNewsById(id);
    }
    
    @Override
    public List<News> findNews(int limit, int offset) {
        return dao.findNews(limit, offset);
    }
    
    @Override
    public List<News> findNewsSummary(int limit, int offset) {
        return dao.findNewsSummary(limit, offset);
    }

    @Override
    public List<News> findAllNewsSummary() {
        return dao.findAllNewsShortSummary();
    }
    
    @Override
    public List<News> findAllNewsFullWithComments() {
        return dao.findAllNewsFullWithComments();
    }

    @Override
    public void saveNews(News news) {
        dao.saveNews(news);
    }

    @Override
    public void updateNews(News news) {
        dao.updateNews(news);
    }

    @Override
    public void deleteNews(Integer id) {
        dao.deleteNews(id);
    }

    @Override
    public void deleteNews(News news) {
        dao.deleteNews(news);
    }

}
