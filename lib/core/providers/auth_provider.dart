import 'package:flutter/material.dart';

enum UserRole { regular, superAdmin, hospitalAdmin }

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });
}

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Mock login logic
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@blood.com') {
      _user = User(
        id: '1',
        email: email,
        name: 'Super Admin',
        role: UserRole.superAdmin,
      );
    } else if (email == 'hospital@blood.com') {
      _user = User(
        id: '2',
        email: email,
        name: 'Hospital Admin',
        role: UserRole.hospitalAdmin,
      );
    } else {
      _user = User(
        id: '3',
        email: email,
        name: 'John Doe',
        role: UserRole.regular,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  Future<void> signup(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _user = User(
      id: '4',
      email: data['email'],
      name: '${data['firstName']} ${data['lastName']}',
      role: UserRole.regular,
    );
    _isLoading = false;
    notifyListeners();
  }
}
