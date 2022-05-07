class UserModel {
  final String? fullName;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? imageUrl;

  final String? userId;

  bool? isMechanic;
  final bool? isOnline;
  final int? lastSeen;

  UserModel(
      {this.userId,
      this.email,
      this.password,
      this.phoneNumber,
      this.fullName,
      this.imageUrl,
      this.isMechanic,
      this.isOnline,
      this.lastSeen});

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'userId': userId,
      'isOnline': true,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      fullName: json['fullName'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      userId: json['userId'],
    );
  }
}
