package com.np.suprimpoudel.bus_buddy.models;

import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
@Getter
@Setter
public class LiveLocationVo {
    private User user;
    private double latitude;
    private double longitude;
    private Vehicle vehicle;
    private int routeId;
    private double distance;
}
