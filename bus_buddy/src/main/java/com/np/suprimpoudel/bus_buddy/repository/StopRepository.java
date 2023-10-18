package com.np.suprimpoudel.bus_buddy.repository;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import com.np.suprimpoudel.bus_buddy.entities.Stop;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface StopRepository extends CrudRepository<Stop, Integer> {
    public Stop findById(int id);

    public List<Stop> findByRouteOrderByOrderNoAsc(Route route);

    @Query("SELECT MAX(orderNo) FROM Stop s WHERE s.route.id = :routeId")
    public int findMaxOrderNo(@Param("routeId") int routeId);

    @Query("SELECT s FROM Stop s WHERE s.route.id = :routeId")
    public List<Stop> findAllByRoute(@Param("routeId") int routeId);

    List<Stop> findByOrderNoGreaterThanEqualAndRoute(int orderNo, Route route);
}
