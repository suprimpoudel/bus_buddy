package com.np.suprimpoudel.bus_buddy.controllers;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import com.np.suprimpoudel.bus_buddy.models.RouteVo;
import com.np.suprimpoudel.bus_buddy.service.RouteService;
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
@RequestMapping("/route")
@CrossOrigin(origins = "http://localhost:3000")

public class RouteController {
    @Autowired
    private RouteService service;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<Route>>> getAll() throws ApiException {
        List<Route> routeList = service.getAll();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all route", routeList));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Route>> add(@RequestBody @Valid Route route) throws ApiException {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created route", service.add(route)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Route>> update(@PathVariable("id") int id, @RequestBody @Valid Route route) throws Exception {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully updated route", service.update(route)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<RouteVo>> find(@PathVariable("id") int id) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched route", service.find(id)));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<Route>>> findByPlaceBetween(@RequestParam(name = "placeOne") int startPlaceId, @RequestParam(name = "placeTwo") int endPlaceId) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched routes consisting of places", service.getRoutesConsistingOf(startPlaceId, endPlaceId)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Null>> delete(@PathVariable("id") int id) throws ApiException {
        service.delete(id);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully delete route", null));
    }
}
