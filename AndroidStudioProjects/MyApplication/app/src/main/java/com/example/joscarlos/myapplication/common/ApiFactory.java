package com.example.joscarlos.myapplication.common;

import com.example.joscarlos.myapplication.service.ApiService;
import com.example.joscarlos.myapplication.service.impl.ApiServiceImpl;

import java.util.Arrays;
import java.util.List;

/**
 * Created by JoséCarlos on 13/11/2015.
 */
public enum ApiFactory {
    INSTANCE;

    private ApiService[] listServices = {new ApiServiceImpl()};

    public ApiService getApi() {
        return listServices[0];
    }
}
