package com.np.suprimpoudel.bus_buddy.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Driver;
import java.util.Date;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class RouteAssessment {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @OneToOne
    @NotNull(message = "Vehicle is required")
    @JoinColumn(name = "vehicle", referencedColumnName = "id")
    private Vehicle vehicle;

    @OneToOne
    @NotNull(message = "Driver is required")
    @JoinColumn(name = "driver", referencedColumnName = "id")
    private User driver;

    @ManyToOne
    @NotNull(message = "Route is required")
    @JoinColumn(name = "route", referencedColumnName = "id")
    private Route route;

    @Temporal(TemporalType.TIMESTAMP)
    @CreationTimestamp
    @Column(name = "created_at")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @UpdateTimestamp
    @Column(name = "updated_at")
    private Date updatedAt;
}
