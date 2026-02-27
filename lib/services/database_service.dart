import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/hospital_model.dart';
import '../models/blood_request_model.dart';
import '../models/inventory_model.dart';
import '../models/notification_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Users Repository ---
  Future<void> saveUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  Stream<UserModel?> streamUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  Stream<List<UserModel>> streamAllUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> toggleUserBan(String uid, bool isBanned) async {
    await _db.collection('users').doc(uid).update({'isBanned': isBanned});
  }

  Future<void> updateUserRoleAndHospital({
    required String uid,
    required String role,
    String? hospitalId,
  }) async {
    await _db.collection('users').doc(uid).update({
      'role': role,
      'hospitalId': hospitalId,
    });
  }

  // --- Hospitals Repository ---
  Future<void> addHospital(HospitalModel hospital) async {
    await _db.collection('hospitals').add(hospital.toMap());
  }

  Future<void> deleteHospital(String hospitalId) async {
    await _db.collection('hospitals').doc(hospitalId).delete();
  }

  Stream<List<HospitalModel>> streamHospitals({
    String? islandGroup,
    String? city,
    String? barangay,
    bool allowAll = false, // Added to show inactive hospitals to Super Admin
  }) {
    Query query = _db.collection('hospitals');

    if (!allowAll) {
      query = query.where('isActive', isEqualTo: true);
    }

    if (islandGroup != null && islandGroup.isNotEmpty) {
      query = query.where('islandGroup', isEqualTo: islandGroup);
    }

    if (city != null && city.isNotEmpty) {
      query = query.where('city', isEqualTo: city);
    }

    if (barangay != null && barangay.isNotEmpty) {
      query = query.where('barangay', isEqualTo: barangay);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
            (doc) => HospitalModel.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          )
          .toList();
    });
  }

  // --- Blood Requests Repository ---
  Future<void> createBloodRequest(BloodRequestModel request) async {
    await _db.collection('blood_requests').add(request.toMap());
  }

  Stream<List<BloodRequestModel>> streamAllBloodRequests() {
    return _db
        .collection('blood_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BloodRequestModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<List<BloodRequestModel>> streamHospitalRequests(String hospitalId) {
    return _db
        .collection('blood_requests')
        .where('hospitalId', isEqualTo: hospitalId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BloodRequestModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    await _db.collection('blood_requests').doc(requestId).update({
      'status': status,
    });
  }

  Future<void> updateRequestStatusWithNotification({
    required BloodRequestModel request,
    required String newStatus,
  }) async {
    // 1. Update the request status
    await updateRequestStatus(request.id!, newStatus);

    // 2. Create a notification for the user
    String title = '';
    String body = '';
    String type = '';

    if (newStatus == 'approved') {
      title = 'Request Approved!';
      body =
          'Your ${request.type} for ${request.bloodType} at ${request.hospitalName} has been approved.';
      type = 'request_approved';
    } else if (newStatus == 'rejected') {
      title = 'Request Rejected';
      body =
          'Sorry, your ${request.type} for ${request.bloodType} at ${request.hospitalName} was rejected.';
      type = 'request_rejected';
    }

    if (title.isNotEmpty) {
      final message = '$title: $body';
      final notification = NotificationModel(
        userId: request.userId,
        message: message,
        isRead: false,
        createdAt: DateTime.now(),
      );

      // Since NotificationModel doesn't have a 'type' field but toMap might need it
      // depends on how we want to handle the UI icons.
      // Looking at the model, it doesn't have 'type'.
      // I'll add 'type' to the Firestore document manually by overriding toMap or using a custom map.
      final data = notification.toMap();
      data['type'] = type;
      data['title'] = title; // For UI compatibility in NotificationsScreen
      data['body'] = body; // For UI compatibility in NotificationsScreen

      await _db.collection('notifications').add(data);
    }
  }

  // --- Inventory Repository ---
  Future<void> updateInventory(
    String hospitalId,
    String bloodType,
    double units,
  ) async {
    await _db
        .collection('hospitals')
        .doc(hospitalId)
        .collection('inventory')
        .doc(bloodType)
        .set({
          'blood_type': bloodType,
          'units': units,
          'last_updated': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<InventoryModel>> streamInventory(String hospitalId) {
    return _db
        .collection('hospitals')
        .doc(hospitalId)
        .collection('inventory')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => InventoryModel.fromMap(doc.data()))
              .toList();
        });
  }

  // --- Notifications Repository ---
  Future<void> sendNotification(NotificationModel notification) async {
    await _db.collection('notifications').add(notification.toMap());
  }

  Stream<List<NotificationModel>> streamUserNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }
}
