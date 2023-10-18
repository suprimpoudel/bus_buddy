package com.np.suprimpoudel.bus_buddy.service;

import com.np.suprimpoudel.bus_buddy.entities.Vehicle;
import com.np.suprimpoudel.bus_buddy.models.VehiclePieChart;
import com.np.suprimpoudel.bus_buddy.repository.VehicleRepository;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class VehicleService {

    private final String zonalPattern = "^[A-Z]{2} \\d{1,2} \\b\\w{2,3}\\b \\d{1,4}$";
    private final String provincePattern = "^PRA-[1-7]-(00[1-9]|0[1-9][0-9]|[1-9][0-9]{2}|999) \\b\\w{2,3}\\b \\d{1,4}$";

    @Autowired
    private VehicleRepository repository;

    public List<Vehicle> getAll() {
        List<Vehicle> vehicles = new ArrayList<>();
        repository.findAll().forEach(vehicles::add);
        return  vehicles;
    }

    public List<Vehicle> getAllUnassignedVehicles() {
        return repository.findUnassignedVehicles();
    }

    public Vehicle add(Vehicle vehicle) throws ApiException {
        if(vehicle.getVehicleNumber().matches(zonalPattern) || vehicle.getVehicleNumber().matches(provincePattern)) {
            return repository.save(vehicle);
        } else {
            throw new ApiException(HttpStatus.BAD_REQUEST, "Please enter a valid vehicle number eg: BA 10 PA 4040 OR PRA-3-001 PA 4040");
        }
    }

    public Vehicle update(Vehicle vehicle) throws ApiException {
       Vehicle v = find(vehicle.getId());
       if(v == null) {
           throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find vehicle with id " + vehicle.getId());
       }else {
           if(vehicle.getVehicleNumber().matches(zonalPattern) || vehicle.getVehicleNumber().matches(provincePattern)) {
               vehicle.setCreatedAt(v.getCreatedAt());
               return repository.save(vehicle);
           } else {
               throw new ApiException(HttpStatus.BAD_REQUEST, "Please enter a valid vehicle number");
           }
       }
    }

    public Vehicle find(int id) throws ApiException {
        Vehicle vehicle = repository.findById(id);
        if(vehicle == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find vehicle with id " + id);
        } else {
            return  vehicle;
        }
    }

    public Vehicle findByVehicleNumber(String vehicleNumber) throws ApiException {
        Vehicle vehicle = repository.findByVehicleNumber(vehicleNumber);
        if(vehicle == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find vehicle with vehicle number " + vehicleNumber);
        } else {
            return  vehicle;
        }
    }

    public void delete(int id) throws ApiException {
        Vehicle vehicle = repository.findById(id);
        if(vehicle == null) {
            throw new ApiException(HttpStatus.NOT_FOUND, "Couldn't find vehicle with id " + id);
        } else {
            repository.delete(vehicle);
        }
    }

    public List<VehiclePieChart> vehiclePieChart() {
        List<VehiclePieChart> vehiclePieCharts = new ArrayList<>();
        var assignedVehicleCount = repository.getAssignedVehicleCount();
        var unAssignedVehicleCount = repository.getUnAssignedVehicleCount();
        vehiclePieCharts.add(new VehiclePieChart("Assigned",  "green", assignedVehicleCount));
        vehiclePieCharts.add(new VehiclePieChart("Un Assigned","orange" ,unAssignedVehicleCount));
        return vehiclePieCharts;
    }

}