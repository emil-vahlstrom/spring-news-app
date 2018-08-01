package com.emva.newsapp.model;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import javax.persistence.CascadeType;
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

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "USER_COMMENT")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Comment implements Serializable {

    private static final long serialVersionUID = 1L;
    private static final Integer LEVEL_NONE = -1;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id = 0;
    
    @Column(name = "reply_id", nullable = true)
    private Integer replyId;

    @NotEmpty
    @Column(name = "text", nullable = false)
    private String text;

    @Column(name = "created", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date created = new Date(System.currentTimeMillis());

    @Column(name = "modified", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date modified = new Date(System.currentTimeMillis());
    
    @Column(name = "active", nullable = false)
    private Boolean isActive = true;
    
    public Boolean isActive() {
        return isActive;
    }
    
    public void setActive(Boolean isActive) {
        this.isActive = isActive;
    }


    /*
     * default fetch-types ------------------------------------------------
     * OneToMany: LAZY ----------------------------------------------------
     * ManyToOne: EAGER ---------------------------------------------------
     * ManyToMany: LAZY ---------------------------------------------------
     * OneToOne: EAGER ----------------------------------------------------
     */

    @JsonIgnore
    @ManyToOne(cascade = { CascadeType.ALL })
    @JoinColumn(name = "reply_id", insertable = false, updatable = false)
    private Comment parent; // parent

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "parent", cascade = CascadeType.ALL)
    @OrderBy("created DESC, id DESC")
    private List<Comment> children = new LinkedList<Comment>();
    
    public Integer countAllComments() {
        return 1 + countComments(this.getChildren(), LEVEL_NONE);
    }
    
    public Integer countCommentsByLevel(Integer level) {
        level--;
        if (level > 0) {
            return 1 + countComments(this.getChildren(), level); 
        }
        return 0;
    }
    
    public Integer countComments(List<Comment> comments, Integer level) {
        Integer numComments = comments.size();
        
        if (level != 1 || level == LEVEL_NONE) {
            for (Comment comment : comments) {
                numComments += comment.countComments(comment.getChildren(), (level - 1));
            }
        }
        
        return numComments;
    }
    
    /**
     * Takes a list of Comments and returns a new sublist according to offset and limit.
     * @param offset the offset, starts with 0 for beginning of list
     * @param limit the number of item maximally returned
     * @param comments the list to get the sublist from
     * @return a sublist of Comment-objects
     */
    public static List<Comment> slice(Integer offset, Integer limit, List<Comment> comments) {
        Integer fromIndex = offset * limit;
        Integer toIndex = offset * limit + limit;
        toIndex = toIndex > comments.size() ? comments.size() : toIndex;
        
        List<Comment> sublist = null;
        
        try {
            sublist = comments.subList(fromIndex, toIndex);
        } catch (IllegalArgumentException | NullPointerException e) {
            // Invalid arguments: out of index. Initalize an empty list and return
            sublist = new ArrayList<Comment>(0);
        }
        
        return sublist;
    }
    
    /**
     * Iterates through a Parent-comment's children nodes and populate one list of all children, including the parent.
     * @return a list with all children-comments including the top-parent
     */
    @JsonIgnore
    public List<Comment> getAllComments() {
        List<Comment> allComments = new ArrayList<Comment>(Arrays.asList(this));
        populateChildrenList(this.getChildren(), allComments);
        return allComments;
    }
    
    /**
     * Recursive method to go through all comments-nodes and populate one list with all comments
     * @param comments the current child
     * @param allComments a list that will be populated with all child-comments.
     */
    private void populateChildrenList(List<Comment> comments, List<Comment> allComments) {
        if (comments.size() > 0) {
            for (Comment comment : comments) {
                allComments.add(comment);
                populateChildrenList(comment.getChildren(), allComments);
            }
        }
    }
    
    /* TODO: evaluate if lazy fetching is really needed, since user is @ManyToOne */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinTable(name = "APP_USER_USER_COMMENT", joinColumns = {
            @JoinColumn(name = "comment_id") }, inverseJoinColumns = { @JoinColumn(name = "user_id") })
    private User user;
    
    @JsonIgnore
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinTable(name = "USER_COMMENT_NEWS", 
        joinColumns = @JoinColumn(name = "comment_id"),
        inverseJoinColumns = @JoinColumn(name = "news_id"))
    private News news;
    
    public News getNews() {
        return news;
    }
    
    public void setNews(News news) {
        this.news = news;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Comment() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getReplyId() {
        return replyId;
    }

    public void setReplyId(Integer replyId) {
        this.replyId = replyId;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
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

    public Comment getParent() {
        return parent;
    }

    public void setParent(Comment parent) {
        this.parent = parent;
    }

    public List<Comment> getChildren() {
        return children;
    }

    public void setChildren(List<Comment> children) {
        this.children = children;
    }

    @Override
    public String toString() {
        int maxLength = 50;
        int textLength = text.length() <= maxLength ? text.length() : maxLength;
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        String createdFormatted = created != null ? df.format(created) : "NULL";
        String modifiedFormatted = modified != null ? df.format(modified) : "NULL";
        return "Comment [id=" + id + ", replyId=" + replyId + ", text=" + text.substring(0, textLength) 
            + " created=" + createdFormatted + ", modified=" + modifiedFormatted + "]";
    }

    public static Comparator<Comment> getComparator() {
        return new CommentComparator();
    }

}
