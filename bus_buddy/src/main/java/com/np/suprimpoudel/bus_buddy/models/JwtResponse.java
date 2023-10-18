package com.np.suprimpoudel.bus_buddy.models;

import com.np.suprimpoudel.bus_buddy.entities.User;
import lombok.*;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Builder
public class JwtResponse {
    private String jwtToken;
    private User user;
}
