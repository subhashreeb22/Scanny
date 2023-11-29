class AdminModel {
  String? uid;
  String? email;
  String? userName;

  AdminModel({this.uid, this.email, this.userName});

  // receiving data from server
  factory AdminModel.fromMap(map) {
    return AdminModel(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
    };
  }
}