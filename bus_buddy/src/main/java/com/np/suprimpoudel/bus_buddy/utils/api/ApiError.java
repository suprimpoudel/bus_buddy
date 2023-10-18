package com.np.suprimpoudel.bus_buddy.utils.api;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.http.HttpStatus;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ApiError {
    private String message;
    private HttpStatus code;
    private String timeStamp;
    List<ApiSubError> errors;
}
