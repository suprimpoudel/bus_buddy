package com.np.suprimpoudel.bus_buddy.models;

import lombok.*;

@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ChangePassword {
    private String oldPassword;
    private String newPassword;
}
