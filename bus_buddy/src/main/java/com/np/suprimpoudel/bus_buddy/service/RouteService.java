package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import com.np.suprimpoudel.bus_buddy.models.RouteVo;
import com.np.suprimpoudel.bus_buddy.repository.*;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.enums.UserType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class RouteService {
    @Autowired
    private RouteRepository repository;

    @Autowired
    private PlaceRepository placeRepository;

    @Autowired
    private VehicleRepository vehicleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private StopRepository stopRepository;

    public List<Route> getAll() {
        List<Route> routeList = new ArrayList<>();
        repository.findAll().forEach(routeList::add);
        return routeList;
    }

    public List<Route> getRoutesConsistingOf(int startPlaceId, int endPlaceId) throws ApiException {
        var startPlace = placeRepository.findById(startPlaceId);
        var endPlace = placeRepository.findById(endPlaceId);
        if (startPlace == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Place not found for id " + startPlaceId);
        }
        if (endPlace == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Place not found for id " + endPlaceId);
        }
        return repository.findRoutesByStartAndEndPlaces(startPlace, endPlace);
    }

    public RouteVo find(int id) throws ApiException {
        Route r = repository.findById(id);
        if (r == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Route not found for id " + id);
        } else {
            var stopCount = stopRepository.findAllByRoute(r.getId());
            var driverCount = userRepository.findDriversByRoute(UserType.DRIVER, r.getId());
            var vehicleCount = vehicleRepository.findDriversByRoute(r.getId());
            return new RouteVo(
                    r.getId(),
                    r.getName(),
                    r.getIsRoundAboutRoute(),
                    r.getStartDestination(),
                    r.getEndDestination(),
                    stopCount.size(),
                    driverCount,
                    vehicleCount
            );
        }
    }

    public Route add(Route r) throws ApiException {
        if ((r.getEndDestination().getId() == r.getStartDestination().getId()) && !r.getIsRoundAboutRoute()) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "Start and end destination cannot be same unless it is a round about route");
        } else if (r.getEndDestination().getId() == r.getStartDestination().getId()) {
            r.setIsRoundAboutRoute(false);
        }
        return repository.save(r);
    }

    public Route update(Route r) throws ApiException {
        return repository.save(r);
    }

    public void delete(int id) throws ApiException {
        Route r = repository.findById(id);
        if (r == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Route not found for id " + id);
        } else {
            repository.delete(r);
        }
    }
}
