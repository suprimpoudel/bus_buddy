package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import com.np.suprimpoudel.bus_buddy.entities.RouteAssessment;
import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import com.np.suprimpoudel.bus_buddy.models.RouteAssessmentVisualization;
import com.np.suprimpoudel.bus_buddy.repository.RouteAssessmentRepository;
import com.np.suprimpoudel.bus_buddy.repository.RouteRepository;
import com.np.suprimpoudel.bus_buddy.repository.UserRepository;
import com.np.suprimpoudel.bus_buddy.repository.VehicleRepository;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.enums.UserType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class RouteAssessmentService {
    @Autowired
    private RouteAssessmentRepository repository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private VehicleRepository vehicleRepository;
    @Autowired
    private RouteRepository routeRepository;

    public List<RouteAssessment> getAll() {
        List<RouteAssessment> routeAssessments = new ArrayList<>();
        repository.findAll().forEach(routeAssessments::add);
        return routeAssessments;
    }

    public RouteAssessment find(int id) throws ApiException {
        RouteAssessment routeAssessment = repository.findById(id);
        if (routeAssessment == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Route assessment with not found for id " + id);
        } else {
            return routeAssessment;
        }
    }

    public RouteAssessment findByDriver(User driver) throws ApiException {
        User user = userRepository.findById(driver.getId());
        if(user != null) {
            RouteAssessment routeAssessment = repository.findByDriver(user);
            if(routeAssessment == null) {
                throw new ApiException(HttpStatus.NOT_FOUND, "No route has been assigned for user with id " + user.getId());
            } else {
                return routeAssessment;
            }
        } else {
            throw new ApiException(HttpStatus.NOT_FOUND, "User not found for id " + driver.getId());
        }
    }

    public RouteAssessment findByVehicle(Vehicle vehicle) throws ApiException {
        Vehicle newVehicle = vehicleRepository.findById(vehicle.getId());
        if(newVehicle != null) {
            RouteAssessment routeAssessment = repository.findByVehicle(newVehicle);
            if(routeAssessment == null) {
                throw new ApiException(HttpStatus.NOT_FOUND, "No route has been assigned for vehicle with id " + newVehicle.getId());
            } else {
                return routeAssessment;
            }
        } else {
            throw new ApiException(HttpStatus.NOT_FOUND, "Vehicle not found for id " + vehicle.getId());
        }
    }

    public RouteAssessment assignRouteAndVehicleToDriver(RouteAssessment routeAssessment) throws ApiException {
        User user = userRepository.findById(routeAssessment.getDriver().getId());
        Route route = routeRepository.findById(routeAssessment.getRoute().getId());
        Vehicle vehicle = vehicleRepository.findById(routeAssessment.getVehicle().getId());
        if(route == null) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "Route not found");
        }  else {
            routeAssessment.setRoute(route);
        }
        if(vehicle == null) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "Vehicle not found");
        }  else {
            routeAssessment.setVehicle(vehicle);
        }
        if(user.getUserType() != UserType.DRIVER) {
            throw new ApiException(HttpStatus.BAD_REQUEST, "Cannot assign route to normal user");
        }  else {
            routeAssessment.setDriver(user);
        }
        return repository.save(routeAssessment);
    }

    public void delete(int id) throws ApiException {
        RouteAssessment routeAssessment = repository.findById(id);
        if (routeAssessment == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Route assessment with not found for id " + id);
        } else {
            repository.delete(routeAssessment);
        }
    }

    public RouteAssessmentVisualization routeAssessmentVisualizations() {
        List<RouteAssessment> routeAssessments = new ArrayList<>();
        repository.findAll().forEach(routeAssessments::add);
        Map<Route, Long> routeToVehicleCount = routeAssessments.stream()
                .collect(Collectors.groupingBy(RouteAssessment::getRoute, Collectors.counting()));
        RouteAssessmentVisualization routeAssessmentVisualization = new RouteAssessmentVisualization();
        routeAssessmentVisualization.setRouteNames(new ArrayList<>(routeToVehicleCount.keySet().stream().map(Route::getName).collect(Collectors.toList())));
        routeAssessmentVisualization.setRouteVehiclesCount(new ArrayList<>(routeToVehicleCount.values()));
return routeAssessmentVisualization;
    }
}

