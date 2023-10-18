package com.np.suprimpoudel.bus_buddy.models;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class EstimatedArrivalTime {
    @NotNull(message = "Latitude is required")
    private double latitude;
    @NotNull(message = "Longitude is required")
    private double longitude;
    @NotNull(message = "Driver id is required")
    private int driverId;
}