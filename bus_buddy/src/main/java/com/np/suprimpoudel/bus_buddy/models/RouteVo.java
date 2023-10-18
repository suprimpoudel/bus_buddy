package com.np.suprimpoudel.bus_buddy.models;

import com.np.suprimpoudel.bus_buddy.entities.Place;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RouteVo {
    private int id;

    private String name;

    private Boolean isRoundAboutRoute;

    private Place startDestination;

    private Place endDestination;

    private int totalStops;

    private long totalDrivers;

    private long totalVehicles;
}
