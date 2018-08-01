package com.emva.newsapp.model;

public enum State {
    
    ACTIVE("Active"),
    INACTIVE("Inactive"),
    DELETED("Deleted"),
    LOCKED("Locked");

    private String state;
    
    private State(final String state) {
        this.state = state;
    }
    
    public String getState() {
        return state;
    }
}
