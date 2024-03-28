class UserModel {
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.profilePic,
    required this.phoneNumber,
  });
  String? uid;
  String? name;
  String? email;
  String? bio;
  String? profilePic;
  String? phoneNumber;

  // from json
  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    bio = json['bio'] ?? '';
    phoneNumber = json['phoneNumber'] ?? '';
    profilePic = json['profilePic'] ?? '';
  }

  // to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['email'] = email;
    data['bio'] = bio;
    data['profilePic'] = profilePic;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
