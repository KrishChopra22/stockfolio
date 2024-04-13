class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? bio;
  final String? profilePic;
  final String? phoneNumber;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.profilePic,
    required this.phoneNumber,
  });

  // from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePic: json['profilePic'] ?? '',
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? bio,
    String? profilePic,
    String? phoneNumber,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
