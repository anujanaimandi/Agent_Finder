package com.realestate.models;

import java.time.LocalDate;

public class Review {
    private int id;
    private int clientId;
    private int agentId;
    private int rating;
    private String comment;
    private LocalDate reviewDate;

    public Review(int id, int clientId, int agentId, int rating, String comment) {
        this.id = id;
        this.clientId = clientId;
        this.agentId = agentId;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = LocalDate.now();
    }
}
