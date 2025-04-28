package com.realestate.models;

import java.io.Serializable;

public abstract class User implements Serializable {
    protected int id;
    protected String username;
    protected String password;
    protected String email;
    protected String phone;
    protected String userType; // "client" or "agent"

    public User(int id, String username, String password, String email, String phone, String userType) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.phone = phone;
        this.userType = userType;
    }
}
