package com.np.suprimpoudel.bus_buddy.repository;

import com.np.suprimpoudel.bus_buddy.entities.Place;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface PlaceRepository extends CrudRepository<Place, Integer> {
    public Place findById(int id);
}
