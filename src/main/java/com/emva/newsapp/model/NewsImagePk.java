package com.emva.newsapp.model;

import javax.persistence.Embeddable;
import javax.persistence.ManyToOne;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Embeddable
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class NewsImagePk implements java.io.Serializable {

    private static final long serialVersionUID = -2291161104490530756L;
    
    @JsonIgnore
    private News news;
    private Image image;
    
    public NewsImagePk() {}
    
    @ManyToOne
    public News getNews() {
        return news;
    }
    
    public void setNews(News news) {
        this.news = news;
    }
    
    @ManyToOne
    public Image getImage() {
        return image;
    }
    
    public void setImage(Image image) {
        this.image = image;
    }
    
//    public void setCategory(Image image) {
//        this.image = image;
//    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((image == null) ? 0 : image.hashCode());
        result = prime * result + ((news == null) ? 0 : news.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        NewsImagePk other = (NewsImagePk) obj;
        if (image == null) {
            if (other.image != null)
                return false;
        } else if (!image.equals(other.image))
            return false;
        if (news == null) {
            if (other.news != null)
                return false;
        } else if (!news.equals(other.news))
            return false;
        return true;
    }
}
