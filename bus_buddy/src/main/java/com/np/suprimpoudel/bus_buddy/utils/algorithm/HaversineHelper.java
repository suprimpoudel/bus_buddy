package com.np.suprimpoudel.bus_buddy.utils.algorithm;

import com.np.suprimpoudel.bus_buddy.models.LiveLocation;
import com.np.suprimpoudel.bus_buddy.utils.api.ApiException;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

public class HaversineHelper {
    public static double calculateDistanceBetweenPoints(double lat1, double lon1, double lat2, double lon2)  {
        final double R = 6371.0;

        double latDistance = Math.toRadians(lat2 - lat1);
        double lonDistance = Math.toRadians(lon2 - lon1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            return R * c * 1000;
    }
    public static double calculateEstimatedArrivalTime(List<LiveLocation> locations, double endingLatitude, double endingLongitude) throws ApiException {
            var distance= calculateDistanceBetweenPoints(locations.getLast().getLatitude(), locations.getLast().getLongitude(), endingLatitude, endingLongitude);
            var averageSpeed = calculateAverageSpeed(locations);
            return ((distance/1000) / averageSpeed) * 60;
    }

    private static double calculateAverageSpeed(List<LiveLocation> liveLocations) {
        double totalDistance = 0;
        long totalTime = 0;
        for (int i = 1; i < liveLocations.size(); i++) {
            LiveLocation currentLocation = liveLocations.get(i);
            LiveLocation previousLocation = liveLocations.get(i - 1);
            var distance= calculateDistanceBetweenPoints(currentLocation.getLatitude(), currentLocation.getLongitude(), previousLocation.getLatitude(), previousLocation.getLongitude());
            totalDistance += distance;
            totalTime += parseTimestamp(currentLocation.getTimeStamp()) - parseTimestamp(previousLocation.getTimeStamp());
        }
        return totalDistance / totalTime * 3600;
    }

    public static long parseTimestamp(String timestamp) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSX");
        Date date;
        try {
            date = dateFormat.parse(timestamp);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        return date.getTime();
    }
}
