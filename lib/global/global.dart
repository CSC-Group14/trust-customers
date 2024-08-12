import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_details_info.dart';
import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? currentUserInfo;
List driversList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String chosenDriverId = "";
String driverCarDetails = "";
String carModel = "";
String carNumber = "";
String carType = "";
String driverName = "";
String driverPhone = "";
double countRatingStars = 0.0;
String titleStarsRating = "";
