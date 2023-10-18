package com.np.suprimpoudel.bus_buddy.repository;

import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import com.np.suprimpoudel.bus_buddy.utils.enums.UserType;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface VehicleRepository extends CrudRepository<Vehicle, Integer> {
    public Vehicle findById(int id);

    public Vehicle findByVehicleNumber(String vehicleNumber);

    @Query("SELECT COUNT(v) FROM Vehicle v WHERE v.id NOT IN (SELECT ra.vehicle.id FROM RouteAssessment ra)")
    long getUnAssignedVehicleCount();

    @Query("SELECT COUNT(v) FROM Vehicle v WHERE v.id IN (SELECT ra.vehicle.id FROM RouteAssessment ra)")
    long getAssignedVehicleCount();

    @Query("SELECT COUNT(v) FROM Vehicle v WHERE v.id IN (SELECT ra.vehicle.id FROM RouteAssessment ra WHERE ra.route.id = :routeId)")
    long findDriversByRoute(int routeId);

    @Query("SELECT v FROM Vehicle v WHERE v.id NOT IN (SELECT ra.vehicle.id FROM RouteAssessment ra)")
    List<Vehicle> findUnassignedVehicles();
}
