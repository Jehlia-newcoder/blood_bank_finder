import 'package:flutter/material.dart';
import '../widgets/hospital_admin_drawer.dart';

class HospitalAdminDashboard extends StatelessWidget {
  const HospitalAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hospital Admin Dashboard')),
      drawer: const HospitalAdminDrawer(),
      body: const Center(child: Text('Hospital Overview and Inventory')),
    );
  }
}
