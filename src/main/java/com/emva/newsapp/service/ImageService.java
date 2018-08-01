package com.emva.newsapp.service;

import java.util.List;

import com.emva.newsapp.model.Image;

public interface ImageService {

    public Image findImageById(Integer id);
    public List<Image> findAllImages();
    public void saveImage(Image image);
    public void updateImage(Image image);
    public void deleteImage(Integer id);
    public void deleteImage(Image image);
}
