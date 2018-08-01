package com.emva.newsapp.model;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity(name = "News")
@Table(name = "NEWS")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class News implements java.io.Serializable {

    private static final long serialVersionUID = 225390376410090843L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id = 0;

    @NotEmpty
    @Column(name = "headline", nullable = false)
    private String headline;

    @NotEmpty
    @Column(name = "lead", nullable = false)
    private String lead;

    @NotEmpty
    @Basic(fetch = FetchType.LAZY) // ignored by hibernate
    @Column(name = "body", nullable = false)
    private String body;

    @Temporal(TemporalType.TIMESTAMP)
    private Date created;

    @Temporal(TemporalType.TIMESTAMP)
    private Date modified;

    /*
     * default fetch-types ------------------------------------------------
     * OneToMany: LAZY ----------------------------------------------------
     * ManyToOne: EAGER ---------------------------------------------------
     * ManyToMany: LAZY ---------------------------------------------------
     * OneToOne: EAGER ----------------------------------------------------
     */

    @ManyToOne(fetch = FetchType.EAGER) // default is eager
    @JoinTable(name = "app_user_news", joinColumns = @JoinColumn(name = "news_id"), inverseJoinColumns = @JoinColumn(name = "user_id"))
    private User author;

    @OneToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "USER_COMMENT_NEWS", joinColumns = { @JoinColumn(name = "news_id") }, inverseJoinColumns = {
            @JoinColumn(name = "comment_id") })
    @OrderBy("created DESC, id DESC")
    private List<Comment> comments = new LinkedList<Comment>();
    
//    @OneToMany(fetch = FetchType.EAGER) 
//    @JoinTable(
//            name = "NEWS_IMAGE_HEAD", 
//            joinColumns = { @JoinColumn(name = "news_id")}, 
//            inverseJoinColumns = { @JoinColumn(name = "image_id")})
//    private List<Image> headImages = new LinkedList<Image>();
    
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "pk.news"/*, cascade=CascadeType.ALL*/) 
    private List<NewsImageHead> newsImageHeads = new LinkedList<NewsImageHead>();
    
 
    public News() {
    }

    // public News(Integer id, @NotEmpty String text, Date created, Date
    // modified) {
    // super();
    // this.id = id;
    // this.text = text;
    // this.created = created;
    // this.modified = modified;
    // }

    public News(@NotEmpty String body) {
        this.body = body;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getHeadline() {
        return headline;
    }

    public void setHeadline(String headline) {
        this.headline = headline;
    }

    public String getLead() {
        return lead;
    }

    public void setLead(String lead) {
        this.lead = lead;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public Date getModified() {
        return modified;
    }

    public void setModified(Date modified) {
        this.modified = modified;
    }

    public User getAuthor() {
        return author;
    }

    public void setAuthor(User author) {
        this.author = author;
    }

    public List<Comment> getComments() {
        return comments;
    }
    
    public List<Comment> getComments(Integer offset, Integer limit) {
        return Comment.slice(offset, limit, comments);
    }
    
    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
    
//    public List<Image> getHeadImages() {
//        return headImages;
//    }
//    
//    public void setHeadImages(List<Image> headImages) {
//        this.headImages = headImages;
//    }
    
    public List<NewsImageHead> getNewsImageHeads() {
        return newsImageHeads;
    }

    public void setNewsImageHeads(List<NewsImageHead> newsImageHeads) {
        this.newsImageHeads = newsImageHeads;
    }

    @Override
    public String toString() {
        // int maxLength = 50;
        // int textLength = body.length() <= 50 ? body.length() : maxLength;
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String createdFormatted = created != null ? df.format(created) : "NULL";
        String modifiedFormatted = modified != null ? df.format(modified) : "NULL";
        return "News [id=" + id + ", headline=" + headline + ", lead=" + lead +
        // ", body=" + body.substring(0, textLength) + ", " +
                ", created=" + createdFormatted + ", modified=" + modifiedFormatted
                // + ", comments=" + comments
                + ", publisher=" + (author != null ? author.getSsoId() : "NULL") + 
//                ", headImages.size(): " + headImages.size() +
//                ", newsImageHeads.size(): " + newsImageHeads.size() +
                "]"
                ;
    }

}
