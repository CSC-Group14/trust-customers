const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
const logger = require("firebase-functions/logger");


const notifications = require("./notifications");

exports.sendRideRequestNotification = notifications.sendRideRequestNotification;


// HTTP Function Example
exports.helloWorld = functions.https.onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

// Database Trigger Function for Sending Notifications
exports.sendRideRequestNotification =
 functions.database.ref(
     "/AllRideRequests/{requestId}",
 )
     .onCreate(async (snapshot, context) => {
       const rideRequest = snapshot.val();
       const driverId = rideRequest.driverId;

       try {
         // Fetch the driver's device token
         const driverRef = admin.database().ref(`/Drivers/${driverId}`);
         const driverSnapshot = await driverRef.once("value");
         const driverData = driverSnapshot.val();
         const deviceToken = driverData.deviceToken;

         if (deviceToken) {
           // Notification payload
           const payload = {
             notification: {
               title: "New Ride Request",
               body: `You have a new ride request from ${rideRequest.userName}`,
             },
           };

           // Send the notification
           await admin.messaging().sendToDevice(deviceToken, payload);
           logger.info("Notification sent successfully");
         } else {
           logger.warn("No device token found for driver");
         }
       } catch (error) {
         logger.error("Error sending notification:", error);
       }
     });
