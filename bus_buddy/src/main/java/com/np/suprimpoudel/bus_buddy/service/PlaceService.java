package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.Place;
import com.np.suprimpoudel.bus_buddy.repository.PlaceRepository;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
@Component
public class PlaceService {
    @Autowired
    private PlaceRepository repository;

    public List<Place> getAll() {
        List<Place> placeList = new ArrayList<>();
        repository.findAll().forEach(placeList::add);
        return  placeList;
    }

    public Place find(int id) throws ApiException {
        Place p = repository.findById(id);
        if(p == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find place with id " + id);
        } else {
            return  p;
        }
    }

    public Place add(Place place) {
        return repository.save(place);
    }
    public Place update(Place place) {
        Place p = repository.findById(place.getId());
        if(p == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find place with id " + place.getId());
        } else {
            place.setCreatedAt(p.getCreatedAt());
            return repository.save(place);
        }
    }

    public void deletePlace(int id) throws ApiException{
        Place place = repository.findById(id);
        if(place == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find place with id " + id);
        } else {
            repository.delete(place);
        }
    }
}
