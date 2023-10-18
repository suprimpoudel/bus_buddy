package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.models.EstimatedArrivalTime;
import com.np.suprimpoudel.bus_buddy.models.LiveLocationVo;
import com.np.suprimpoudel.bus_buddy.models.UserLocation;
import com.np.suprimpoudel.bus_buddy.service.FirebaseService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class FirebaseController {

    @Autowired
    private FirebaseService service;

    @PostMapping("/nearbyVehicles")
    public ResponseEntity<ApiResponse<List<LiveLocationVo>>> getDataFromFirebase(@RequestBody @Valid UserLocation userLocation) throws ApiException {
        List<LiveLocationVo> liveLocations = service.getDataFromFirebase(userLocation);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all nearby vehicles", liveLocations));
    }

    @PostMapping("/calculateEAT")
    public ResponseEntity<ApiResponse<Double>> getEATFromFirebase(@RequestBody @Valid EstimatedArrivalTime arrivalTime) throws ApiException {
        double estimatedArrivalTime = service.getEATBasedOnDriver(arrivalTime);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully calculated estimated arrival time", estimatedArrivalTime));
    }
}