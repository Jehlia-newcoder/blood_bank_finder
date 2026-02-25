import 'package:flutter/material.dart';
import '../widgets/super_admin_drawer.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Admin Dashboard')),
      drawer: const SuperAdminDrawer(),
      body: const Center(child: Text('Global Overview and Controls')),
    );
  }
}
