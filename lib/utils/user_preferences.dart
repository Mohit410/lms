import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lms/model/user_model.dart';
import 'package:lms/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserFName(String fName) async =>
      await _preferences?.setString(userFNameKey, fName);

  static Future setUserLName(String lName) async =>
      await _preferences?.setString(userLNameKey, lName);

  static Future setUserUid(String uid) async =>
      await _preferences?.setString(userUidKey, uid);

  static Future setUserRole(String role) async =>
      await _preferences?.setString(userRoleKey, role);

  static String getUserFName() => _preferences?.getString(userFNameKey) ?? "";

  static String getUserLName() => _preferences?.getString(userLNameKey) ?? "";

  static String getUserUid() => _preferences?.getString(userUidKey) ?? "";

  static String getUserRole() => _preferences?.getString(userRoleKey) ?? userR;

  static Future clearPreferences() async => await _preferences?.clear();

  static void saveUserPreferences(User user) {
    UserModel userModel;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((value) async {
      userModel = UserModel.fromMap(value.data());
      await UserPreferences.setUserRole("${userModel.userRole}");
      await UserPreferences.setUserFName("${userModel.firstName}");
      await UserPreferences.setUserLName("${userModel.lastName}");
      await UserPreferences.setUserUid("${userModel.uid}");
    });
  }
}

bool isAdmin() {
  print("******${UserPreferences.getUserRole()}*******");
  return UserPreferences.getUserRole() == adminR;
}
