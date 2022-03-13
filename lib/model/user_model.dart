class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? userRole = "user";
  String? mobileNumber;

  UserModel(
      {this.uid,
      this.email,
      this.firstName,
      this.lastName,
      this.userRole,
      this.mobileNumber});

//receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        userRole: map['role'],
        mobileNumber: map['mobile_no']);
  }

  //sending data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': userRole,
      'mobile_no': mobileNumber,
    };
  }

  toJson() {
    return {
      'uid': uid,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': userRole,
      'mobile_no': mobileNumber,
    };
  }
}
