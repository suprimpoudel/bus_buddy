package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import com.np.suprimpoudel.bus_buddy.entities.Stop;
import com.np.suprimpoudel.bus_buddy.repository.RouteRepository;
import com.np.suprimpoudel.bus_buddy.repository.StopRepository;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class StopService {
    @Autowired
    private StopRepository repository;

    @Autowired
    private RouteRepository routeRepository;


    public Stop find(int id) throws ApiException {
        Stop s = repository.findById(id);
        if(s == null) {
            throw new ApiException(HttpStatus.NOT_FOUND,"Stop not found for id " + id);
        } else {
            return s;
        }
    }
    public List<Stop> getAll() {
        List<Stop> stops = new ArrayList<>();
        repository.findAll().forEach(stops::add);
        return stops;
    }

    public List<Stop> getAllStopByRoute(int routeId) throws ApiException {
        Route r = routeRepository.findById(routeId);
        if(r == null) {
          throw new ApiException(HttpStatus.NOT_FOUND, "Route not found for id " + routeId);
        } else {
            return new ArrayList<>(repository.findByRouteOrderByOrderNoAsc(r));
        }
    }

    public Stop add(Stop stop) {
        var stopsList = repository.findAllByRoute(stop.getRoute().getId());
        if(stopsList != null && !stopsList.isEmpty()) {
            var maxOrderNo = repository.findMaxOrderNo(stop.getRoute().getId());
            if(stop.getOrderNo() > maxOrderNo) {
                stop.setOrderNo(maxOrderNo + 1);
            } else {
                var orderNo = stop.getOrderNo();
                repository.findByOrderNoGreaterThanEqualAndRoute(orderNo, stop.getRoute()).forEach(stops -> {
                    var stopOrderNo = stops.getOrderNo();
                    stops.setOrderNo(stopOrderNo + 1);
                    repository.save(stops);
                });
                repository.save(stop);
            }
        } else {
            stop.setOrderNo(1);
        }
        return repository.save(stop);
    }

    public Stop update(Stop stop) {
        var stopsList = repository.findAllByRoute(stop.getRoute().getId());
        if(stopsList != null && !stopsList.isEmpty()) {
            var maxOrderNo = repository.findMaxOrderNo(stop.getRoute().getId());
            if(stop.getOrderNo() > maxOrderNo) {
                stop.setOrderNo(maxOrderNo + 1);
            } else {
                var orderNo = stop.getOrderNo();
                repository.findByOrderNoGreaterThanEqualAndRoute(orderNo, stop.getRoute()).forEach(stops -> {
                    var stopOrderNo = stops.getOrderNo();
                    stops.setOrderNo(stopOrderNo + 1);
                    repository.save(stops);
                });
                repository.save(stop);
            }
        } else {
            stop.setOrderNo(1);
        }
        return repository.save(stop);
    }

    public void delete(int id) throws ApiException {
        Stop stop = repository.findById(id);
        if(stop == null) {
            throw new ApiException(HttpStatus.NOT_FOUND,"Stop not found for id " + id);
        } else {
            var count = repository.findByRouteOrderByOrderNoAsc(stop.getRoute());
            if(count.size() > 2) {
                if(repository.findMaxOrderNo(stop.getRoute().getId()) == stop.getOrderNo()) {
                    repository.delete(stop);
                } else {
                    var orderNo = stop.getOrderNo();
                    repository.findByOrderNoGreaterThanEqualAndRoute(orderNo, stop.getRoute()).forEach(stops -> {
                        var stopOrderNo = stops.getOrderNo();
                        stops.setOrderNo(stopOrderNo - 1);
                        repository.save(stops);
                    });
                    repository.delete(stop);
                }
                repository.delete(stop);
            } else {
                throw new ApiException(HttpStatus.BAD_REQUEST,"There must be a least 2 stops for a route");
            }
        }
    }
}
