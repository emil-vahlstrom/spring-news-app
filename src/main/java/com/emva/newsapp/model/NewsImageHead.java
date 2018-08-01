package com.emva.newsapp.model;

import javax.persistence.AssociationOverride;
import javax.persistence.AssociationOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "NEWS_IMAGE_HEAD")
@AssociationOverrides({
        @AssociationOverride(name = "pk.news",
                joinColumns = @JoinColumn(name = "NEWS_ID")), /* or just ID? (probably not, lileky referring to column in join table)*/
        @AssociationOverride(name = "pk.image",
                joinColumns = @JoinColumn(name = "IMAGE_ID"))
})
public class NewsImageHead {
    
    @JsonIgnore
    private NewsImagePk pk;
    @Column(name = "size", nullable = false)
    private Integer size;
    @Column(name = "thumbnail", nullable = false)
    private Boolean thumbnail;
    
    public NewsImageHead() {}
    
    @EmbeddedId
    public NewsImagePk getPk() {
        return pk;
    }
    
    public void setPk(NewsImagePk pk) {
        this.pk = pk;
    }
    
    @JsonIgnore
    @Transient
    public News getNews() {
        return getPk().getNews();
    }
    
    public void setNews(News news) {
        getPk().setNews(news);
    }
    
    @Transient
    public Image getImage() {
        return getPk().getImage();
    }
    
    public void setImage(Image image) {
        getPk().setImage(image);
    }
    
    public Integer getSize() {
        return size;
    }
    public void setSize(Integer size) {
        this.size = size;
    }
    public Boolean getThumbnail() {
        return thumbnail;
    }
    public void setThumbnail(Boolean thumbnail) {
        this.thumbnail = thumbnail;
    }
}
