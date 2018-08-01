package com.emva.newsapp.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.emva.newsapp.model.Image;

@Repository("imageDao")
public class ImageDaoImpl extends AbstractDao<Integer, Image> implements ImageDao {

    @Override
    protected Class<Image> getEntityClass() {
        return Image.class;
    }
    
    @Override
    public Image findImageById(Integer id) {
        return findById(id);
    }

    @Override
    public List<Image> findAllImages() {
        return findAll();
    }

    @Override
    public void saveImage(Image image) {
        persist(image);
    }

    @Override
    public void updateImage(Image image) {
        merge(image);
    }

    @Override
    public void deleteImage(Integer id) {
        delete(id);
    }

    @Override
    public void deleteImage(Image image) {
        delete(image);
    }

}
