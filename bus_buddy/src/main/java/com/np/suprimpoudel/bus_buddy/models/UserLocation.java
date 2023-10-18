package com.np.suprimpoudel.bus_buddy.models;

import jakarta.validation.constraints.NotNull;
import lombok.*;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@ToString
public class UserLocation {
    @NotNull(message = "Latitude is required")
    private double latitude;
    @NotNull(message = "Longitude is required")
    private double longitude;
    @NotNull(message = "Distance is required")
    private int distance;
    @NotNull(message = "Requester user id is required")
    private int userId;
}
