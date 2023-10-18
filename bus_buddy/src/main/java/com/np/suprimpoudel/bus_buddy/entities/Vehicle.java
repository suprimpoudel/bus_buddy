package com.np.suprimpoudel.bus_buddy.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.Instant;
import java.util.Date;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Vehicle {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @NotNull(message = "Seating capacity is required")
    @Min(value = 7, message = "Minimum seat capacity of vehicle must be 7")
    @Max(value = 100, message = "Maximum seat capacity of vehicle must not be greater than 100")
    private int seatingCapacity;

    @Column(name = "model", nullable = false)
    private String model;

    @NotNull(message = "Vehicle number is required")
    @NotEmpty(message = "Vehicle number cannot be empty")
    @Column(name = "vehicle_number", nullable = false, unique = true)
    private String vehicleNumber;

    @CreationTimestamp
    @Column(name = "created_at")
    private Instant createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private Instant updatedAt;
}
