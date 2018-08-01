package com.emva.newsapp.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.emva.newsapp.dao.ImageDao;
import com.emva.newsapp.model.Image;

@Service(value = "imageService")
@Transactional
public class ImageServiceImpl implements ImageService {

    @Autowired
    @Qualifier(value = "imageDao")
    ImageDao dao;
    
    @Override
    public Image findImageById(Integer id) {
        return dao.findImageById(id);
    }

    @Override
    public List<Image> findAllImages() {
        return dao.findAllImages();
    }

    @Override
    public void saveImage(Image image) {
        dao.saveImage(image);
    }

    @Override
    public void updateImage(Image image) {
        dao.updateImage(image);
    }

    @Override
    public void deleteImage(Integer id) {
        dao.deleteImage(id);
    }

    @Override
    public void deleteImage(Image image) {
        dao.deleteImage(image);
    }

}
