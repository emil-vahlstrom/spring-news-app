package com.emva.newsapp.model;

import java.util.Comparator;

public class CommentComparator implements Comparator<Comment> {

    @Override
    public int compare(Comment o1, Comment o2) {
//        if (o1.getId() < o2.getId()) {
//            return 1;
//        } else if (o1.getId() > o2.getId()) {
//            return -1;
//        } else {
//            return 0; 
//        }
        return o1.getId() - o2.getId();
    }
    
}