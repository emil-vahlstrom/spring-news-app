package com.emva.newsapp.dao;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.hibernate.HibernateException;

public abstract class AbstractDao<PK extends Serializable, T> {
    private Class<T> persistentClass;

    public AbstractDao() {
        this.persistentClass = getEntityClass();
    }

    protected abstract Class<T> getEntityClass();

    @PersistenceContext
    private EntityManager entityManager;
    
    public EntityManager getEntityManager() {
        return entityManager;
    }
    
    protected T findById(PK key) {
        return entityManager.find(persistentClass, key);
    }

    protected List<T> findAll() {
        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<T> criteriaQuery = builder.createQuery(persistentClass);
        Root<T> root = criteriaQuery.from(persistentClass);
        criteriaQuery.select(root);
        List<T> entities = entityManager.createQuery(criteriaQuery).getResultList();
        
        return entities;
    }

    /**
     * Make a transient instance persistent. This operation cascades to
     * associated instances if the association is mapped with cascade="persist"
     * 
     * @param entity
     */
    protected void persist(T entity) {
        entityManager.persist(entity);
    }
    
    /**
     * Copy the state of the given object onto the persistent object with the
     * same identifier. If there is no persistent instance currently associated
     * with the session, it will be loaded. Return the persistent instance. If
     * the given instance is unsaved, save a copy of and return it as a newly
     * persistent instance. The given instance does not become associated with
     * the session. This operation cascades to associated instances if the
     * association is mapped with cascade="merge"
     * 
     * @param entity
     */
    protected void merge(T entity) {
        entityManager.merge(entity);
    }

    protected void delete(PK key) {
        T entity = findById(key);
        if (entity != null) {
            delete(entity);
        }
    }

    /**
     * Remove a persistent instance from the datastore. The argument may be an
     * instance associated with the receiving Session or a transient instance
     * with an identifier associated with existing persistent state. This
     * operation cascades to associated instances if the association is mapped
     * with cascade="delete"
     * 
     * NOTE: Also works with detached entities since detached entities are merged
     * before calling {@link EntityManager#remove(Object)})
     * 
     * @param entity
     */
    protected void delete(T entity) {
        entity = entityManager.contains(entity) ? entity : entityManager.merge(entity);
        entityManager.remove(entity);
    }
    
    /**
     * Finds entities that equals the value of the entity's property
     * @param entityPropertyName the property name for the entity, that's mapped to the database column
     * @param value the value that needs to be equal to the entity's property name
     * @return
     */
    public List<T> findByValue(String entityPropertyName, Object value) {
        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<T> criteriaQuery = builder.createQuery(persistentClass);
        Root<T> root = criteriaQuery.from(persistentClass);
        criteriaQuery.where(builder.equal(root.get(entityPropertyName), value));
        List<T> entities = entityManager.createQuery(criteriaQuery).getResultList();
        return entities;
    }
    
    /**
     * Finds entities that equals the values of the entity's properties
     * @param equals a map containing property names(entity-property mapped to database-column) and values
     * @param isAscending true is orderBy is ascending, false if descending, if null then @param orderBy is ignored
     * @param orderBy column name to order by
     * @return
     */
    public List<T> findByValue(Map<String, Object> equals, boolean isAscending, String orderBy) {
        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<T> criteriaQuery = builder.createQuery(persistentClass);
        Root<T> root = criteriaQuery.from(persistentClass);
        
        for (String propertyName : equals.keySet()) {
            criteriaQuery.where(builder.equal(root.get(propertyName), equals.get(propertyName)));
        }
        
        if (orderBy != null) {
            if (isAscending) {
                criteriaQuery.orderBy(builder.asc(root.get(orderBy)));                
            } else {
                criteriaQuery.orderBy(builder.desc(root.get(orderBy)));
            }
        }
        
        List<T> entities = entityManager.createQuery(criteriaQuery).getResultList();
        return entities;
    }
    
    /**
     * If the DAO has more unique fields than PK, use this method to access the
     * unique field name with it's value. Should not be used for columns that
     * doesn't contain unique data (like first_name or favorite_color)
     * 
     * @param key
     *            the column name
     * @param value
     *            the column's value
     * @return the entity if exactly one is found, or null if not found or more
     *         than one found
     */
    protected T uniqueResultOrNull(String key, Object value) {
        CriteriaBuilder builder = entityManager.getCriteriaBuilder();
        CriteriaQuery<T> criteriaQuery = builder.createQuery(persistentClass);
        Root<T> root = criteriaQuery.from(persistentClass);
        criteriaQuery.where(builder.equal(root.get(key), value));
        List<T> results = entityManager.createQuery(criteriaQuery).getResultList();

        if (results.size() == 1) {
            return results.get(0);
        } else {
            return null;
        }
    }
    
    protected T uniqueResult(String key, Object value) {
        T entity = uniqueResultOrNull(key, value);
        
        if (entity == null) {
            throw new HibernateException("No unique result found!");
        }
        return entity;
    }
}
