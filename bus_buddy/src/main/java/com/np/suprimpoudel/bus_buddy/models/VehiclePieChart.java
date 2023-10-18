package com.np.suprimpoudel.bus_buddy.models;

import lombok.*;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class VehiclePieChart {
    private String label;
    private String color;
    private long value;
}
