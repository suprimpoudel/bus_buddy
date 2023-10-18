package com.np.suprimpoudel.bus_buddy.controllers;


import com.np.suprimpoudel.bus_buddy.entities.Place;
import com.np.suprimpoudel.bus_buddy.service.PlaceService;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/place")
@CrossOrigin(origins = "http://localhost:3000")

public class PlaceController {
    @Autowired
    private PlaceService service;

    @GetMapping("/all")
    public ResponseEntity<ApiResponse<List<Place>>> getAll() throws ApiException {
        List<Place> placeList = service.getAll();
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched all place", placeList));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<Place>> add(@RequestBody @Valid Place place) throws ApiException {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully created place", service.add(place)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Place>> update(@PathVariable("id") int id, @RequestBody @Valid Place place) throws Exception {
        return ResponseEntity.status(HttpStatus.CREATED).body(new ApiResponse<>("Successfully updated place", service.update(place)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Place>> find(@PathVariable("id") int id) throws ApiException {
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully fetched place", service.find(id)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Integer>> deletePlaceById(@PathVariable("id") int id) throws ApiException {
        service.deletePlace(id);
        return ResponseEntity.status(HttpStatus.OK).body(new ApiResponse<>("Successfully deleted place", id));
    }
}
