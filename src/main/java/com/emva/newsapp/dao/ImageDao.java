package com.emva.newsapp.dao;

import java.util.List;

import com.emva.newsapp.model.Image;

public interface ImageDao {

    public Image findImageById(Integer id);
    public List<Image> findAllImages();
    public void saveImage(Image image);
    public void updateImage(Image image);
    public void deleteImage(Integer id);
    public void deleteImage(Image image);
}
