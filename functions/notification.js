const functions = require("firebase-functions");
const admin = require("firebase-admin");
const logger = require("firebase-functions/logger");

admin.initializeApp();

exports.sendRideRequestNotification =
 functions.database.ref(
     "/AllRideRequests/{requestId}",
 )
     .onCreate(async (snapshot, context) => {
       const rideRequest = snapshot.val();
       const driverId = rideRequest.driverId;

       try {
         const driverRef = admin.database().ref(`/Drivers/${driverId}`);
         const driverSnapshot = await driverRef.once("value");
         const driverData = driverSnapshot.val();
         const deviceToken = driverData.deviceToken;

         if (deviceToken) {
           const payload = {
             notification: {
               title: "New Ride Request",
               body: `You have a new ride request from ${rideRequest.userName}`,
             },
           };

           await admin.messaging().sendToDevice(deviceToken, payload);
           logger.info("Notification sent successfully");
         } else {
           logger.warn("No device token found for driver");
         }
       } catch (error) {
         logger.error("Error sending notification:", error);
       }
     });
