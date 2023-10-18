package com.np.suprimpoudel.bus_buddy.models;

import lombok.*;

@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
@Getter
@Setter
public class LiveLocation {
    private int driverId;
    private int vehicleId;
    private int routeId;
    private double latitude;
    private double longitude;
    private String timeStamp;
}
