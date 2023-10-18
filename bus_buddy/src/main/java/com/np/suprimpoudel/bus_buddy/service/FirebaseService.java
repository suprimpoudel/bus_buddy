package com.np.suprimpoudel.bus_buddy.service;

import com.google.firebase.database.*;
import com.np.suprimpoudel.bus_buddy.models.EstimatedArrivalTime;
import com.np.suprimpoudel.bus_buddy.models.LiveLocation;
import com.np.suprimpoudel.bus_buddy.models.LiveLocationVo;
import com.np.suprimpoudel.bus_buddy.models.UserLocation;
import com.np.suprimpoudel.bus_buddy.utils.algorithm.HaversineHelper;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Stream;
import java.util.stream.StreamSupport;

@Service
public class FirebaseService {

    Logger logger = LoggerFactory.getLogger(FirebaseService.class);
    @Autowired
    private UserService userService;

    @Autowired
    private RouteService routeService;

    @Autowired
    private VehicleService vehicleService;

    public List<LiveLocationVo> getDataFromFirebase(UserLocation userLocation) throws ApiException {
        try {
            double userLat = userLocation.getLatitude();
            double userLng = userLocation.getLongitude();

            DatabaseReference database = FirebaseDatabase.getInstance().getReference();
            DatabaseReference ref = database.child("liveLocation").getRef();

            CompletableFuture<List<LiveLocationVo>> firebaseDataFuture = new CompletableFuture<>();

            ref.addListenerForSingleValueEvent(new ValueEventListener() {
                @Override
                public void onDataChange(DataSnapshot dataSnapshot) {
                    List<LiveLocationVo> listOfObjectsVo = new ArrayList<>();
                    List<DataSnapshot> childrens = new ArrayList<>();
                    dataSnapshot.getChildren().forEach(childrens::add);
                    if(childrens.isEmpty()) {
                        firebaseDataFuture.completeExceptionally(new Throwable("No live sessions found"));
                    } else {
                        for (DataSnapshot snapshot : childrens) {
                            List<DataSnapshot> dataSnapshots = new ArrayList<>();
                            snapshot.getChildren().forEach(dataSnapshots::add);
                            if(!dataSnapshots.isEmpty()) {
                                var liveLocationDataSnapshot = dataSnapshots.getLast();

                                LiveLocation liveLocation = liveLocationDataSnapshot.getValue(LiveLocation.class);

                                double busLat = liveLocation.getLatitude();
                                double busLng =liveLocation.getLongitude();

                                double distance = HaversineHelper.calculateDistanceBetweenPoints(userLat, userLng, busLat, busLng);
                                if (distance <= userLocation.getDistance()) {
                                    LiveLocationVo liveLocationVo = new LiveLocationVo();
                                    var driver = userService.find(liveLocation.getDriverId());
                                    var vehicle = vehicleService.find(liveLocation.getVehicleId());
                                    liveLocationVo.setUser(driver);
                                    liveLocationVo.setRouteId(liveLocation.getRouteId());
                                    liveLocationVo.setDistance(distance);
                                    liveLocationVo.setVehicle(vehicle);
                                    liveLocationVo.setLatitude(liveLocation.getLatitude());
                                    liveLocationVo.setLongitude(liveLocation.getLongitude());

                                    listOfObjectsVo.add(liveLocationVo);
                                }
                            }
                        }

                        firebaseDataFuture.complete(listOfObjectsVo);
                    }
                }

                @Override
                public void onCancelled(DatabaseError databaseError) {
                    throw new ApiException(HttpStatus.BAD_REQUEST, databaseError.getMessage());
                }
            });

            CompletableFuture<Void> allFutures = CompletableFuture.allOf(firebaseDataFuture);

            allFutures.join();

            return firebaseDataFuture.join();
        } catch (Exception e) {
            throw new ApiException(HttpStatus.BAD_REQUEST, e.getLocalizedMessage());
        }
    }

    public Double getEATBasedOnDriver(EstimatedArrivalTime arrivalTime) throws ApiException {
        String key = "Driver " + arrivalTime.getDriverId();
        logger.warn(key);

        DatabaseReference database = FirebaseDatabase.getInstance().getReference();
        DatabaseReference ref = database.child("liveLocation").getRef();

        CompletableFuture<Double> firebaseDataFuture = new CompletableFuture<>();

        ref.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                double estimatedArrivalTime;

                Stream<DataSnapshot> dataSnapshotStream = StreamSupport.stream(dataSnapshot.getChildren().spliterator(), false);

                Optional<DataSnapshot> filteredSnapshot = dataSnapshotStream
                        .filter(snapshot -> key.equals(snapshot.getKey()))
                        .findFirst();

                if (filteredSnapshot.isPresent()) {
                    DataSnapshot snapshot = filteredSnapshot.get();
                    List<LiveLocation> liveLocationList = new ArrayList<>();
                    for (DataSnapshot childSnapshot : snapshot.getChildren()) {
                        LiveLocation liveLocation = childSnapshot.getValue(LiveLocation.class);
                        liveLocationList.add(liveLocation);
                    }
                    if(liveLocationList.size() >= 5) {
                        estimatedArrivalTime = HaversineHelper.calculateEstimatedArrivalTime(liveLocationList, arrivalTime.getLatitude(), arrivalTime.getLongitude());

                        firebaseDataFuture.complete(estimatedArrivalTime);
                    } else {
                        firebaseDataFuture.completeExceptionally(new Throwable("Not enough information to calculate ETA"));
                    }
                } else {
                    firebaseDataFuture.completeExceptionally(new Throwable("No live sessions found"));
                }

            }

            @Override
            public void onCancelled(DatabaseError databaseError) {
                firebaseDataFuture.completeExceptionally(databaseError.toException());
            }
        });

        CompletableFuture<Void> allFutures = CompletableFuture.allOf(firebaseDataFuture);

        allFutures.join();

        return firebaseDataFuture.join();
    }
}
