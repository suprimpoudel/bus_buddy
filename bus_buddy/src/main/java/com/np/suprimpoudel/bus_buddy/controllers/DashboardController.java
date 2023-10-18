package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.Place;
import com.np.suprimpoudel.bus_buddy.models.Dashboard;
import com.np.suprimpoudel.bus_buddy.service.DashboardService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/dashboard")
@CrossOrigin(origins = "http://localhost:3000")
public class DashboardController {

    @Autowired
    private DashboardService service;
    @GetMapping("/admin")
    public ResponseEntity<ApiResponse<Dashboard>> getAdminDashboard() throws ApiException {
        Dashboard dashboard = service.getDashboardData();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched dashboard", dashboard));
    }
}
