package com.np.suprimpoudel.bus_buddy.repository;

import com.np.suprimpoudel.bus_buddy.entities.RouteAssessment;
import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import org.springframework.data.repository.CrudRepository;

public interface RouteAssessmentRepository extends CrudRepository<RouteAssessment, Integer> {
    public RouteAssessment findById(int id);

    public RouteAssessment findByDriver(User user);

    public RouteAssessment findByVehicle(Vehicle vehicle);
}
