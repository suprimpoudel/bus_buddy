package com.np.suprimpoudel.bus_buddy.repository;

import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.utils.enums.UserType;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.Date;
import java.util.List;

public interface UserRepository extends CrudRepository<User, Integer> {
    public User findById(int id);

    public User findByEmail(String email);

    public List<User> findByUserType(UserType userType);
    @Query("SELECT COUNT(u) FROM User u WHERE u.createdAt BETWEEN :startDate AND :endDate AND u.userType = :userType")
    long countUsersByCreatedAtBetween(
            @Param("startDate") Date startDate,
            @Param("endDate") Date endDate,
            UserType userType);

    @Query("SELECT u FROM User u WHERE u.id NOT IN (SELECT ra.driver.id FROM RouteAssessment ra) AND u.userType = :userType")
    List<User> findUnassignedDrivers(UserType userType);

    @Query("SELECT COUNT(u) FROM User u WHERE u.id IN (SELECT ra.driver.id FROM RouteAssessment ra WHERE ra.route.id = :routeId) AND u.userType = :userType")
    long findDriversByRoute(UserType userType, int routeId);
}
