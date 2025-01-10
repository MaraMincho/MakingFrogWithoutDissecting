package com.example.demo3.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SimpleRestController {
    @RequestMapping("/")
    public String hello() {
        return "Hello";
    }

    @RequestMapping("/a")
    public String hello2() {
        return "Hello2";
    }
}
