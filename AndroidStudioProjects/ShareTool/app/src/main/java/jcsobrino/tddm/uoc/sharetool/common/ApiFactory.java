package jcsobrino.tddm.uoc.sharetool.common;

import com.example.joscarlos.myapplication.service.ApiService;
import com.example.joscarlos.myapplication.service.impl.ApiServiceImpl;

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
