package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.models.ChangePassword;
import com.np.suprimpoudel.bus_buddy.service.UserService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
@CrossOrigin(origins = "http://localhost:3000")

public class UserController {
    @Autowired
    private UserService service;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<User>>> getAll() throws ApiException {
        List<User> userList = service.getAllUser();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all users", userList));
    }

    @GetMapping("/unassigned")
    public ResponseEntity<ApiResponse<List<User>>> getAllUnassignedDriver() throws ApiException {
        List<User> userList = service.getAllUnassignedDrivers();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all un assigned driver", userList));
    }

    @GetMapping("driver/all")
    public ResponseEntity<ApiResponse<List<User>>> getAllDrivers() throws ApiException {
        List<User> userList = service.getAllDrivers();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all drivers", userList));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<User>> add(@RequestBody @Valid User user) throws ApiException {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created user", service.add(user)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<User>> update(@PathVariable("id") int id, @RequestBody User user) {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully updated user", service.update(user, id)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<User>> find(@PathVariable("id") int id) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched user", service.find(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable("id") int id) throws ApiException {
        service.delete(id);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched user", null));
    }

    @PutMapping("change-password/{id}")
    public ResponseEntity<ApiResponse<Boolean>> changePassword(@PathVariable("id") int id, @RequestBody ChangePassword changePassword) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully changed password", service.changePassword(changePassword, id)));
    }
}
