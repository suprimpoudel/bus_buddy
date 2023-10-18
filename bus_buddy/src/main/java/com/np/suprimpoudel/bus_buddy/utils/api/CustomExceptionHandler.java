package com.np.suprimpoudel.bus_buddy.utils.api;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@RestControllerAdvice
public class CustomExceptionHandler {
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ApiError handleInvalidArgumentException(MethodArgumentNotValidException exception) {
        ApiError customException = new ApiError();
        customException.setCode(HttpStatus.BAD_REQUEST);
        customException.setMessage("Data validation failed");
        customException.setTimeStamp(LocalDateTime.now().toString());

        List<ApiSubError> customExceptionList = new ArrayList<>();
        exception.getBindingResult().getFieldErrors().forEach(error -> {
            customExceptionList.add(new ApiSubError(error.getField(), error.getDefaultMessage()));
        });

        customException.setErrors(customExceptionList);

        return customException;
    }

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<ApiError> handleApiCustomException(ApiException exception) {
        ApiError customException = new ApiError();
        customException.setCode(exception.getHttpStatus());
        customException.setMessage(exception.getLocalizedMessage());
        customException.setTimeStamp(LocalDateTime.now().toString());
        customException.setErrors(exception.getApiSubErrors());
        return ResponseEntity.status(exception.getHttpStatus()).body(customException);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleExceptionInGeneral(Exception exception) {
        ApiError customException = new ApiError();
        customException.setCode(HttpStatus.BAD_REQUEST);
        customException.setMessage(exception.getLocalizedMessage());
        customException.setTimeStamp(LocalDateTime.now().toString());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(customException);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiError> handleDataIntegrityError(DataIntegrityViolationException exception) {
        ApiError customException = new ApiError();
        customException.setCode(HttpStatus.CONFLICT);
        customException.setMessage(exception.getMostSpecificCause().getMessage());
        customException.setTimeStamp(LocalDateTime.now().toString());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(customException);
    }
}
