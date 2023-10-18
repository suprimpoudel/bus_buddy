package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.RouteAssessment;
import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import com.np.suprimpoudel.bus_buddy.service.RouteAssessmentService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/routeAssessment")
@CrossOrigin(origins = "http://localhost:3000")

public class RouteAssessmentController {

    Logger logger = LoggerFactory.getLogger(RouteAssessmentController.class);
    @Autowired
    private RouteAssessmentService service;


    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<RouteAssessment>>> getAll() throws ApiException {
        List<RouteAssessment> routeAssessments = service.getAll();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all route assessment", routeAssessments));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RouteAssessment>> find(@PathVariable("id") int id) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched route assessment", service.find(id)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<RouteAssessment>> getRouteByVehicle(@RequestParam(name = "vehicleId") int vehicleId) throws ApiException {
        Vehicle vehicle = new Vehicle();
        vehicle.setId(vehicleId);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all route assessment by vehicle", service.findByVehicle(vehicle)));
    }

    @GetMapping("/driver")
    public ResponseEntity<ApiResponse<RouteAssessment>> getRouteByDriver(@RequestParam(name = "driverId") int driverId) throws ApiException {
        User user = new User();
        user.setId(driverId);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all route assessment by driver", service.findByDriver(user)));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<RouteAssessment>> add(@RequestBody @Valid RouteAssessment routeAssessment) throws ApiException {
        logger.warn("Route is " + routeAssessment.getRoute().getId() + " User is " + routeAssessment.getDriver().getId() + " Vehicle is " + routeAssessment.getVehicle().getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created route assessment", service.assignRouteAndVehicleToDriver(routeAssessment)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<RouteAssessment>> update(@RequestBody @Valid RouteAssessment routeAssessment) throws ApiException {
        logger.warn("Route is " + routeAssessment.getRoute().getId() + " User is " + routeAssessment.getDriver().getId() + " Vehicle is " + routeAssessment.getVehicle().getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created route assessment", service.assignRouteAndVehicleToDriver(routeAssessment)));
    }
}
