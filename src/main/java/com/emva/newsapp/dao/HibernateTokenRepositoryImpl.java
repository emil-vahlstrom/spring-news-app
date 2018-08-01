package com.emva.newsapp.dao;

import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.emva.newsapp.model.PersistentLogin;

@Repository("tokenRepositoryDao")
@Transactional
public class HibernateTokenRepositoryImpl extends AbstractDao<String, PersistentLogin> 
    implements PersistentTokenRepository {
    
    static final Logger logger = LoggerFactory.getLogger(HibernateTokenRepositoryImpl.class);

    @Override
    protected Class<PersistentLogin> getEntityClass() {
        return PersistentLogin.class;
    }

    @Override
    public void createNewToken(PersistentRememberMeToken token) {
        logger.info("Creating Token for user : {}", token.getUsername());
        PersistentLogin persistentLogin = new PersistentLogin();
        persistentLogin.setUsername(token.getUsername());
        persistentLogin.setSeries(token.getSeries());
        persistentLogin.setToken(token.getTokenValue());
        persistentLogin.setLast_used(token.getDate());
        persist(persistentLogin);
    }
    
    @Override
    public PersistentRememberMeToken getTokenForSeries(String seriesId) {
        logger.info("Fetch token if any for seriesId : {}", seriesId);
        try {
            PersistentLogin persistentLogin = uniqueResult("series", seriesId);
            
            return new PersistentRememberMeToken(persistentLogin.getUsername(), persistentLogin.getSeries(), 
                    persistentLogin.getToken(), persistentLogin.getLast_used());
        } catch (Exception e) {
            logger.info("Token not found");
            return null;
        }
    }

    @Override
    public void removeUserTokens(String username) {
        logger.info("Removing Token if any for user : {}", username);
        PersistentLogin persistentLogin = uniqueResultOrNull("username", username);
        if (persistentLogin != null) {
            logger.info("rememberMe was selected");
            delete(persistentLogin);
        }
    }

    @Override
    public void updateToken(String seriesId, String tokenValue, Date lastUsed) {
        logger.info("Updating token for seriesId : {}", seriesId);
        PersistentLogin persistentLogin = findById(seriesId);
        persistentLogin.setToken(tokenValue);
        persistentLogin.setLast_used(lastUsed);
        merge(persistentLogin);
    }
}
 