package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.models.Dashboard;
import com.np.suprimpoudel.bus_buddy.models.DashboardValue;
import com.np.suprimpoudel.bus_buddy.utils.enums.UserType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class DashboardService {

    @Autowired
    private UserService service;

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private RouteAssessmentService routeAssessmentService;

    public Dashboard getDashboardData() {
        Dashboard dashboard = new Dashboard();
        var users = service.getAllUser().size();
        dashboard.setUser(new DashboardValue(users, service.getPercentageIncrease(UserType.USER)));
        var drivers = service.getAllDrivers().size();
        dashboard.setDriver(new DashboardValue(drivers, service.getPercentageIncrease(UserType.DRIVER)));
        dashboard.setVehicleData(vehicleService.vehiclePieChart());
        dashboard.setRouteAssessmentVisualization(routeAssessmentService.routeAssessmentVisualizations());
        return dashboard;
    }
}
