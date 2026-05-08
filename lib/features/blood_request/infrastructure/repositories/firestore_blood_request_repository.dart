import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/blood_request.dart';
import '../../domain/repositories/blood_request_repository.dart';
import '../mappers/blood_request_mapper.dart';

class FirestoreBloodRequestRepository implements IBloodRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // TODO: Centralize this config
  static const String _apiBaseUrl = kIsWeb ? 'http://localhost:8000' : 'http://192.168.1.11:8000';

  @override
  Stream<List<BloodRequestEntity>> getAllRequests() {
    return _firestore
        .collection('blood_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BloodRequestMapper.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<BloodRequestEntity>> getUserRequests(String userId) {
    return _firestore
        .collection('blood_requests')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BloodRequestMapper.fromFirestore(doc))
            .toList());
  }

  @override
  Stream<List<BloodRequestEntity>> getHospitalRequests(String hospitalId) {
    return _firestore
        .collection('blood_requests')
        .where('hospitalId', isEqualTo: hospitalId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BloodRequestMapper.fromFirestore(doc))
            .toList());
  }

  @override
  Future<BloodRequestEntity?> getRequestById(String id) async {
    final doc = await _firestore.collection('blood_requests').doc(id).get();
    return doc.exists ? BloodRequestMapper.fromFirestore(doc) : null;
  }

  @override
  Future<void> createRequest(BloodRequestEntity request) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/blood-requests/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(BloodRequestMapper.toJson(request)),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final data = jsonDecode(response.body);
        throw Exception(data['detail'] ?? 'Failed to create blood request');
      }
    } catch (e) {
      throw Exception('Connection error: Could not reach backend. Is it running? $e');
    }
  }

  @override
  Future<void> updateRequestStatus(String id, String status, {String? adminMessage}) async {
    try {
      final queryParams = {
        'status': status,
        if (adminMessage != null) 'admin_message': adminMessage,
      };
      
      final uri = Uri.parse('$_apiBaseUrl/blood-requests/$id/status')
          .replace(queryParameters: queryParams);

      final response = await http.patch(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        final data = jsonDecode(response.body);
        throw Exception(data['detail'] ?? 'Failed to update request status');
      }
    } catch (e) {
      throw Exception('Connection error: Could not update status via backend. $e');
    }
  }
}
