package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.Stop;
import com.np.suprimpoudel.bus_buddy.service.StopService;
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
@RequestMapping("/stop")
public class StopController {
    @Autowired
    private StopService service;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<Stop>>> getAll() throws ApiException {
        List<Stop> stopList = service.getAll();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all stops", stopList));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Stop>>> getAllStopByRoute(@RequestParam(name = "routeId") int routeId) throws ApiException {
        List<Stop> stopList = service.getAllStopByRoute(routeId);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all stops by route", stopList));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Stop>> add(@RequestBody @Valid Stop stop) throws ApiException {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created stop", service.add(stop)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Stop>> update(@PathVariable("id") int id, @RequestBody @Valid Stop stop) throws Exception {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully updated stop", service.update(stop)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Stop>> find(@PathVariable("id") int id) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched stop", service.find(id)));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Null>> delete(@PathVariable("id") int id) throws ApiException {
        service.delete(id);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully delete stop", null));
    }
}
