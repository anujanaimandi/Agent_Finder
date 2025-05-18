package com.realestate.model;

public class Inquiry {
    private int id;
    private String type; // "property" or "agent"
    private String subject;
    private String clientName;
    private String clientEmail;
    private String message;
    private String status; // "pending", "responded", "resolved"
    private String reply;

    public Inquiry() {}

    public Inquiry(int id, String type, String subject, String clientName, String clientEmail, String message, String status, String reply) {
        this.id = id;
        this.type = type;
        this.subject = subject;
        this.clientName = clientName;
        this.clientEmail = clientEmail;
        this.message = message;
        this.status = status;
        this.reply = reply;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getClientEmail() {
        return clientEmail;
    }

    public void setClientEmail(String clientEmail) {
        this.clientEmail = clientEmail;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}

