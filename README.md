# Bus Buddy - Bus Tracking Project


Bus Buddy is a comprehensive bus tracking system that leverages Spring Boot for the backend, Firebase Database for data storage, React for the admin web application, and Flutter for both the user and driver mobile applications. With Bus Buddy, you can efficiently manage and track your bus fleet, ensuring safe and on-time transportation services for passengers.

## Usage

1. **Set Up Firebase Project:**

   - Create a Firebase project on the [Firebase Console](https://console.firebase.google.com/).
   - In your Firebase project, navigate to **Project settings** and then the **General** tab. Scroll down to find the Firebase SDK snippet. Click on the **Config** option to reveal your Firebase SDK configuration object.

2. **Firebase Configuration for Driver and User Apps:**

   - Download the `google-services.json` file from your Firebase project.
   - Place the `google-services.json` file in the root directory of both the `driver-app` and `user-app` Flutter projects.

3. **Firebase Configuration for Spring Boot Backend:**

   - Download the Firebase Admin SDK private key JSON file from your Firebase project settings. This file contains sensitive information, so keep it secure.
   - Place the downloaded JSON file in the `assets` directory of your Spring Boot project. Ensure it is accessible within the Spring Boot application.

4. **Run the Applications:**

   - Follow the installation steps as previously described to run the admin dashboard, driver app, and user app.
   - The apps are now configured to connect to your Firebase project and the Spring Boot backend for real-time bus tracking and management.

By following these instructions, you'll have the Firebase configuration properly set up for both the Flutter apps and the Spring Boot backend, enabling seamless communication and data synchronization.