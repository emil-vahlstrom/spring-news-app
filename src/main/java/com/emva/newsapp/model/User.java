package com.emva.newsapp.model;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "APP_USER")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class User {
    
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id = 0;

    @NotEmpty
    @Column(name = "sso_id", unique = true, nullable = false)
    private String ssoId;

    @NotEmpty
    @JsonIgnore
    @Basic(fetch = FetchType.LAZY) //never show password hash to client
    @Column(name = "password", nullable = false)
    private String password;
    
    @NotEmpty
    @Column(name = "first_name", nullable = false)
    private String firstName;
    
    @NotEmpty
    @Column(name = "last_name", nullable = false)
    private String lastName;
    
    @NotEmpty
    @Column(name = "email", nullable = false)
    private String email;
    
    @JsonIgnore
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "app_user_user_profile", 
        joinColumns = { @JoinColumn(name = "user_id")},
        inverseJoinColumns = { @JoinColumn(name = "user_profile_id")})
    private Set<UserProfile> userProfiles = new HashSet<UserProfile>();
    
    @JsonIgnore
    @OneToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "APP_USER_NEWS",
            joinColumns = { @JoinColumn(name = "user_id")},
            inverseJoinColumns = { @JoinColumn(name = "news_id")})
    private Set<News> news = new HashSet<News>();
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getSsoId() {
        return ssoId;
    }

    public void setSsoId(String ssoId) {
        this.ssoId = ssoId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Set<UserProfile> getUserProfiles() {
        return userProfiles;
    }

    public void setUserProfiles(Set<UserProfile> userProfiles) {
        this.userProfiles = userProfiles;
    }
    
    public Set<News> getNews() {
        return news;
    }
    
    public void setNews(Set<News> news) {
        this.news = news;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + ((ssoId == null) ? 0 : ssoId.hashCode());
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
        User other = (User) obj;
        if (id != other.id)
            return false;
        if (ssoId == null) {
            if (other.ssoId != null)
                return false;
        } else if (!ssoId.equals(other.ssoId))
            return false;
        return true;
    }

    @Override
    public String toString() {
        return "User [id=" + id + ", ssoId=" + ssoId + ", password=" + password + ", firstName=" + firstName
                + ", lastName=" + lastName + ", email=" + email + ", userProfiles=" + userProfiles + "]";
    }
    
}
