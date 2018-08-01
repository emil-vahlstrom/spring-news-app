package com.emva.newsapp.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;

@Entity
@Table(name = "IMAGE")
public class Image implements java.io.Serializable{

    private static final long serialVersionUID = 2961375956028743914L;

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id = 0;
    
    @NotEmpty
    @Column(name = "uri")
    private String uri;
    
    @Column(name = "external", nullable = false)
    private Boolean isExternal = true;
    
    public Image() {}
    
    public Integer getId() {
        return id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getUri() {
        return uri;
    }
    
    public void setUri(String uri) {
        this.uri = uri;
    }
    
    public Boolean isExternal() {
        return isExternal;
    }
    
    public void isExternal(Boolean isExternal) {
        this.isExternal = isExternal;
    }
    
    @Override
    public String toString() {
        return "Image [id=" + id + ", uri=" + uri + ", isExternal: " + isExternal + "]";
    }
}
