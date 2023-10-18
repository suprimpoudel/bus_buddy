package com.np.suprimpoudel.bus_buddy.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void initialize() throws IOException {
        String projectRootPath = System.getProperty("user.dir");
        String assetsFolderPath = projectRootPath + "/assets/" + "firebase_java_private_key.json";

        FileInputStream serviceAccount =
                new FileInputStream(assetsFolderPath);

        FirebaseOptions options = new FirebaseOptions.Builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .setDatabaseUrl("https://bus-buddy-14320-default-rtdb.firebaseio.com")
                .build();

        FirebaseApp.initializeApp(options);

    }
}
