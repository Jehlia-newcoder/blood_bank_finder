import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/hospital_model.dart';
import '../models/blood_request_model.dart';
import '../models/inventory_model.dart';
import '../models/notification_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Users ---
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    var doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? UserModel.fromMap(doc.data()!) : null;
  }

  Stream<UserModel?> streamUser(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null);
  }

  // --- Hospitals ---
  Future<void> addHospital(HospitalModel hospital) async {
    await _db.collection('hospitals').add(hospital.toMap());
  }

  Stream<List<HospitalModel>> streamHospitals() {
    return _db
        .collection('hospitals')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HospitalModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // --- Blood Requests ---
  Future<void> createBloodRequest(BloodRequestModel request) async {
    await _db.collection('Blood_requests').add(request.toMap());
  }

  Stream<List<BloodRequestModel>> streamBloodRequests() {
    return _db
        .collection('Blood_requests')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => BloodRequestModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    await _db.collection('Blood_requests').doc(requestId).update({
      'status': status,
    });
  }

  // --- Inventory (Sub-collection under hospitals) ---
  Future<void> updateInventory(
    String hospitalId,
    InventoryModel inventory,
  ) async {
    await _db
        .collection('hospitals')
        .doc(hospitalId)
        .collection('inventory')
        .doc(inventory.bloodType)
        .set(inventory.toMap());
  }

  Stream<List<InventoryModel>> streamInventory(String hospitalId) {
    return _db
        .collection('hospitals')
        .doc(hospitalId)
        .collection('inventory')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => InventoryModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // --- Notifications ---
  Future<void> sendNotification(NotificationModel notification) async {
    await _db.collection('notifications').add(notification.toMap());
  }

  Stream<List<NotificationModel>> streamNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'isRead': true,
    });
  }
}
