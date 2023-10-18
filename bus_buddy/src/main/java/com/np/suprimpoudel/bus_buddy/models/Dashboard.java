package com.np.suprimpoudel.bus_buddy.models;

import lombok.*;

import java.util.List;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Dashboard {
    private DashboardValue user;
    private DashboardValue driver;
    private List<VehiclePieChart> vehicleData;
    private RouteAssessmentVisualization routeAssessmentVisualization;
}
