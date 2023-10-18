package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import com.np.suprimpoudel.bus_buddy.service.VehicleService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Null;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/vehicle")
@CrossOrigin(origins = "http://localhost:3000")

public class VehicleController {
    @Autowired
    private VehicleService service;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<Vehicle>>> getAll() throws ApiException {
        List<Vehicle> vehicleList = service.getAll();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all vehicle", vehicleList));
    }

    @GetMapping("/unassigned")
    public ResponseEntity<ApiResponse<List<Vehicle>>> getAllUnassignedVehicles() throws ApiException {
        List<Vehicle> vehicleList = service.getAllUnassignedVehicles();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<List<Vehicle>>("Successfully fetched all vehicles", vehicleList));
    }
    @PostMapping
    public ResponseEntity<ApiResponse<Vehicle>> add(@RequestBody @Valid Vehicle vehicle) throws ApiException {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created vehicle", service.add(vehicle)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Vehicle>> update(@PathVariable("id") int id, @RequestBody @Valid Vehicle vehicle) throws Exception {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully updated vehicle", service.update(vehicle)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Vehicle>> find(@PathVariable("id") int id) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched vehicle", service.find(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Null>> delete(@PathVariable("id") int id) throws ApiException {
        service.delete(id);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully delete vehicle", null));
    }
}
