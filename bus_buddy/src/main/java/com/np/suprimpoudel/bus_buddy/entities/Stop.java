package com.np.suprimpoudel.bus_buddy.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.util.Date;

@Data
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Stop {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @Min(value = 1, message = "Stop time must be at least 1 minute")
    @Column(name = "stop_time", nullable = false)
    private int stopTime;

    @Min(value = 1, message = "Invalid order number")
    @Column(name = "order_no", nullable = false)
    private int orderNo;

    @ManyToOne
    @NotNull(message = "Place is required")
    @JoinColumn(name = "place", referencedColumnName = "id")
    private Place place;

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
