package com.np.suprimpoudel.bus_buddy.repository;

import com.np.suprimpoudel.bus_buddy.entities.Place;
import com.np.suprimpoudel.bus_buddy.entities.Route;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface RouteRepository extends CrudRepository<Route, Integer> {
    public Route findById(int id);

    public Route findByName(String name);

    @Query("SELECT DISTINCT s.route FROM Stop s " +
            "WHERE s.place = :startPlace " +
            "AND s.route IN (SELECT r FROM Stop s2 JOIN s2.route r WHERE s2.place = :endPlace)")
    List<Route> findRoutesByStartAndEndPlaces(
            @Param("startPlace") Place startPlace,
            @Param("endPlace") Place endPlace
    );
}
