package com.np.suprimpoudel.bus_buddy.utils.api;
import lombok.Getter;
import org.springframework.http.HttpStatus;

import java.util.List;

@Getter
public class ApiException extends RuntimeException {

    private final HttpStatus httpStatus;
    private List<ApiSubError> apiSubErrors;

    public ApiException(HttpStatus httpStatus, String message) {
        super(message);
        this.httpStatus = httpStatus;
    }

    public ApiException(HttpStatus httpStatus, String message, List<ApiSubError> apiSubErrors) {
        super(message);
        this.httpStatus = httpStatus;
        this.apiSubErrors = apiSubErrors;
    }

}