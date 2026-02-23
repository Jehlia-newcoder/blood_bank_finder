import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String role; // 'user', 'superadmin', or 'admin'
  final String firstName;
  final String lastName;
  final String fatherName;
  final String mobileNumber;
  final String gender;
  final String bloodGroup;
  final String city;
  final String address;
  final bool isBanned;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.mobileNumber,
    required this.gender,
    required this.bloodGroup,
    required this.city,
    required this.address,
    required this.isBanned,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      fatherName: data['fatherName'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      gender: data['gender'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      city: data['city'] ?? '',
      address: data['address'] ?? '',
      isBanned: data['isBanned'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'fatherName': fatherName,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'city': city,
      'address': address,
      'isBanned': isBanned,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
