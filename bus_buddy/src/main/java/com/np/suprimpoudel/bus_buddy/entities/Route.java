package com.np.suprimpoudel.bus_buddy.entities;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.util.Date;

@Getter
@Setter
@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Route {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int id;

    @NotNull(message = "Route name is required")
    @NotEmpty(message = "Route name must not be empty")
    @Size(min = 3, message = "Route name must be at least 3 characters long")
    @Column(name = "name", nullable = false, unique = true)
    private String name;

    @Column(name = "is_round_about_route")
    private Boolean isRoundAboutRoute;

    @ManyToOne
    @NotNull(message = "Start destination is required")
    @JoinColumn(name = "start_destination", referencedColumnName = "id")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private Place startDestination;

    @ManyToOne
    @NotNull(message = "End destination is required")
    @JoinColumn(name = "end_destination", referencedColumnName = "id")
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private Place endDestination;

    @Temporal(TemporalType.TIMESTAMP)
    @CreationTimestamp
    @Column(name = "created_at")
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @UpdateTimestamp
    @Column(name = "updated_at")
    private Date updatedAt;
}
