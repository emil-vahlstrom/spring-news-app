package com.emva.newsapp.service;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;

import com.emva.newsapp.model.News;

public interface NewsService {
    public News findNewsById(Integer id);
    public List<News> findNews(int limit, int offset);
    public List<News> findNewsSummary(int limit, int offset);
    public List<News> findAllNewsSummary();
    public List<News> findAllNewsFullWithComments();
    @PreAuthorize("hasRole('PUBLISHER')")
    public void saveNews(News news);
    @PreAuthorize("(hasRole('PUBLISHER') AND #news.author.ssoId == authentication.name) || (hasRole('ADMIN'))")
    public void updateNews(News news);
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteNews(Integer id);
    @PreAuthorize("(hasRole('PUBLISHER') AND #news.author.ssoId == authentication.name) OR (hasRole('ADMIN'))")
    public void deleteNews(News news);
}
