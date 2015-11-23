package com.example.joscarlos.myapplication.service;

import com.example.joscarlos.myapplication.common.ToolOrderEnum;
import com.example.joscarlos.myapplication.domain.Tool;
import com.example.joscarlos.myapplication.domain.User;
import com.example.joscarlos.myapplication.dto.ITool;
import com.example.joscarlos.myapplication.dto.IUser;

import java.util.List;

/**
 * Created by JoséCarlos on 13/11/2015.
 */
public interface ApiService {

    IUser login(final String email, final String password);

    List<? extends ITool> findTools(final String name, final Float maxPrice, final Float maxMeters, final Float lat, final Float Lng, final ToolOrderEnum toolOrder);

    ITool getToolById(final Integer id);

    IUser getUserById(final Integer id);
}
