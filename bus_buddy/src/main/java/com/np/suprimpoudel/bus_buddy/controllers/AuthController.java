package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.models.JwtRequest;
import com.np.suprimpoudel.bus_buddy.models.JwtResponse;
import com.np.suprimpoudel.bus_buddy.security.JwtHelper;
import com.np.suprimpoudel.bus_buddy.service.UserService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiError;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private AuthenticationManager manager;


    @Autowired
    private JwtHelper helper;

    private final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private UserService service;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<JwtResponse>> login(@RequestBody JwtRequest request) {

        this.doAuthenticate(request.getEmail(), request.getPassword());


        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getEmail());
        String token = this.helper.generateToken(userDetails);

        JwtResponse response = JwtResponse.builder()
                .jwtToken(token)
                .user(service.findByEmail(userDetails.getUsername())).build();
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully logged in", response));
    }

    @PostMapping("/signup")
    public ResponseEntity<ApiResponse<User>> signUp(@RequestBody @Valid User user) throws ApiException {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created user", service.add(user)));
    }

    private void doAuthenticate(String email, String password) {

        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(email, password);
        try {
            manager.authenticate(authentication);

        } catch (BadCredentialsException e) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "Invalid email or password", null);
        }

    }

    @ExceptionHandler(BadCredentialsException.class)
    public ApiError exceptionHandler() {
        var apiError = new ApiError();
        apiError.setCode(HttpStatus.UNAUTHORIZED);
        apiError.setMessage("Invalid username or password");
        apiError.setTimeStamp(new Date().toString());
        return apiError;
    }
}
