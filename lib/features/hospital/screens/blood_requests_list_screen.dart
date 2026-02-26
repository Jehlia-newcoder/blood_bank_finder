import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/blood_request_model.dart';
import '../../../services/database_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../widgets/hospital_admin_drawer.dart';

class BloodRequestsListScreen extends StatelessWidget {
  const BloodRequestsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final hospitalId = auth.user?.uid;
    final DatabaseService db = DatabaseService();

    return Scaffold(
      appBar: AppBar(title: const Text('Hospital Requests')),
      drawer: const HospitalAdminDrawer(),
      body: hospitalId == null
          ? const Center(child: Text('Unauthorized'))
          : StreamBuilder<List<BloodRequestModel>>(
              stream: db.streamHospitalRequests(hospitalId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No requests for this hospital.'),
                  );
                }

                final requests = snapshot.data!;
                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    final isPending = req.status == 'pending';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text('${req.userName} (${req.bloodType})'),
                        subtitle: Text(
                          'Type: ${req.type} | Contact: ${req.contactNumber}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isPending) ...[
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () =>
                                    db.updateRequestStatusWithNotification(
                                      request: req,
                                      newStatus: 'approved',
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    db.updateRequestStatusWithNotification(
                                      request: req,
                                      newStatus: 'rejected',
                                    ),
                              ),
                            ] else
                              Chip(
                                label: Text(
                                  req.status.toUpperCase(),
                                  style: const TextStyle(fontSize: 10),
                                ),
                                backgroundColor: _getStatusColor(req.status),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green[100]!;
      case 'rejected':
        return Colors.red[100]!;
      case 'completed':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }
}
