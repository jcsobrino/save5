package com.example.joscarlos.myapplication.dto;

/**
 * Created by JoséCarlos on 13/11/2015.
 */
public interface IUser {

    Long getId();

    String getName();

    void setName(String name);

    String getEmail();

    void setEmail(String email);

    String getPassword();

    void setPassword(String password);

    String getImageCode();

    void setImageCode(String imageCode);
}
