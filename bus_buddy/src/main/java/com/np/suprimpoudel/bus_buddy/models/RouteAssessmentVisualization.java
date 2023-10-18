package com.np.suprimpoudel.bus_buddy.models;

import com.np.suprimpoudel.bus_buddy.entities.Route;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class RouteAssessmentVisualization {
    List<String> routeNames;
    List<Long> routeVehiclesCount;
}
