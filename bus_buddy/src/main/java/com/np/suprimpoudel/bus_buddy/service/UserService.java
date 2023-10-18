package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.User;
import com.np.suprimpoudel.bus_buddy.models.ChangePassword;
import com.np.suprimpoudel.bus_buddy.repository.UserRepository;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiSubError;
import com.np.suprimpoudel.bus_buddy.utils.enums.UserType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
public class UserService {

    Logger logger = LoggerFactory.getLogger(DashboardService.class);

    @Autowired
    private UserRepository repository;

    public List<User> getAllUser() {
        return (List<User>) this.repository.findByUserType(UserType.USER);
    }

    public List<User> getAllDrivers() {
        return this.repository.findByUserType(UserType.DRIVER);
    }
    public List<User> getAllUnassignedDrivers() {
        return this.repository.findUnassignedDrivers(UserType.DRIVER);
    }

    public User add(User user) throws ApiException {
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            List<ApiSubError> subErrors = new ArrayList<>();
            subErrors.add(new ApiSubError("password", "Password is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Data validation failed", subErrors);
        } else if (user.getPassword().length() < 8) {
            List<ApiSubError> subErrors = new ArrayList<>();
            subErrors.add(new ApiSubError("password", "Password must be at least 8 characters long"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Data validation failed", subErrors);
        } else if (user.getUserType() == null) {
            List<ApiSubError> subErrors = new ArrayList<>();
            subErrors.add(new ApiSubError("userType", "User type is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Data validation failed", subErrors);
        } else if (user.getUserType() == UserType.DRIVER && (user.getDrivingLicenseNumber() == null || user.getDrivingLicenseNumber().trim().isEmpty())) {
            List<ApiSubError> subErrors = new ArrayList<>();
            subErrors.add(new ApiSubError("drivingLicenseNumber", "Driving license number is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Data validation failed", subErrors);
        }
        return repository.save(user);
    }

    public User update(User user, int id) {
        User existingUser = repository.findById(id);
        if (existingUser == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "User with id " + id + " not found", null);
        } else if (user.getFirstName() == null || user.getFirstName().isEmpty()) {
            List<ApiSubError> apiSubErrors = new ArrayList<>();
            apiSubErrors.add(new ApiSubError("firstName", "First name is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Validation Error", apiSubErrors);
        } else if (user.getLastName() == null || user.getLastName().isEmpty()) {
            List<ApiSubError> apiSubErrors = new ArrayList<>();
            apiSubErrors.add(new ApiSubError("lastName", "Last name is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Validation Error", apiSubErrors);
        } else if (user.getEmail() == null || user.getEmail().isEmpty()) {
            List<ApiSubError> apiSubErrors = new ArrayList<>();
            apiSubErrors.add(new ApiSubError("email", "Email address is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Validation Error", apiSubErrors);
        } else if (user.getPhoneNumber() == null || user.getPhoneNumber().isEmpty()) {
            List<ApiSubError> apiSubErrors = new ArrayList<>();
            apiSubErrors.add(new ApiSubError("phoneNumber", "Phone number is required"));
            throw new ApiException(HttpStatus.BAD_REQUEST, "Validation Error", apiSubErrors);
        }
        existingUser.setFirstName(user.getFirstName());
        existingUser.setLastName(user.getLastName());
        existingUser.setEmail(user.getEmail());
        existingUser.setCreatedAt(user.getCreatedAt());
        existingUser.setPhoneNumber(user.getPhoneNumber());

        return repository.save(existingUser);
    }

    public User find(int id) throws ApiException {
        User u = repository.findById(id);
        if (u == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find user with id " + id);
        } else {
            return u;
        }
    }

    public User findByEmail(String email) throws ApiException {
        User u = repository.findByEmail(email);
        if (u == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find user with email " + email);
        } else {
            return u;
        }
    }

    public void delete(int id) throws ApiException {
        User u = repository.findById(id);
        if (u == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find user with id " + id);
        } else {
            repository.delete(u);
        }
    }

    public double getPercentageIncrease(UserType userType) {
        LocalDate todayDate = LocalDate.now();
        LocalDate yesterdayDate = LocalDate.now().minusDays(1);

        long countYesterday = repository.countUsersByCreatedAtBetween(getStartDate(yesterdayDate), getEndDate(yesterdayDate), userType);
        long countToday = repository.countUsersByCreatedAtBetween(getStartDate(todayDate), getEndDate(todayDate), userType);

        if (countYesterday == 0 && countToday != 0) {
            return 100.0;
        } else  if (countYesterday == 0) {
            return 0.0;
        } else {
            return ((countToday - countYesterday) * 100.0) / countYesterday;
        }
    }

    public Boolean changePassword(ChangePassword changePassword, int id) {
        User u = repository.findById(id);
        if (u == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find user with id " + id);
        } else {
            if (changePassword.getOldPassword() == null || changePassword.getOldPassword().isEmpty()) {
                throw new ApiException(HttpStatus.BAD_REQUEST, "Old password is required");
            } else if (changePassword.getNewPassword() == null || changePassword.getNewPassword().isEmpty()) {
                throw new ApiException(HttpStatus.BAD_REQUEST, "New password is required");
            } else {
                String previousPassword = u.getPassword();
                if (changePassword.getOldPassword().equals(previousPassword)) {
                    if (changePassword.getOldPassword().equals(changePassword.getNewPassword())) {
                        throw new ApiException(HttpStatus.CONFLICT, "New password cannot be as same as old password");
                    } else {
                        u.setPassword(changePassword.getNewPassword());
                        repository.save(u);
                        return true;
                    }
                } else {
                    throw new ApiException(HttpStatus.LOCKED, "Previous password doesn't match");
                }
            }
        }
    }

    private Date getStartDate(LocalDate specificDay) {
        return Date.from(specificDay.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }
    private Date getEndDate(LocalDate specificDay) {
        return Date.from(specificDay.atStartOfDay(ZoneId.systemDefault()).plusHours(23).plusMinutes(59).plusSeconds(59).toInstant());
    }
}
