package com.emva.newsapp.dao;

import java.util.List;

import com.emva.newsapp.model.News;

public interface NewsDao {
    
    public News findNewsById(Integer id);
    public List<News> findNews(int limit, int offset);
    public List<News> findNewsSummary(int limit, int offset);
    public List<News> findAllNewsShortSummary();
    public List<News> findAllNewsFullWithComments();
    public void saveNews(News news);
    public void updateNews(News news);
    public void deleteNews(Integer id);
    public void deleteNews(News news);
}
