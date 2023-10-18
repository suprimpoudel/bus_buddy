package com.np.suprimpoudel.bus_buddy.models;

import lombok.*;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class DashboardValue {
    private int totalValue;
    private double increasePercentage;
}