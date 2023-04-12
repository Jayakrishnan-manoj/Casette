class UserModel {
  String name;
  String email;
  String profilePic;
  String joinedAt;
  String uid;
  String phoneNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.joinedAt,
    required this.uid,
    required this.phoneNumber,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      joinedAt: map['joinedAt'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "uid": uid,
      "profilePic": profilePic,
      "phoneNumber": phoneNumber,
      "joinedAt": joinedAt,
    };
  }
}
