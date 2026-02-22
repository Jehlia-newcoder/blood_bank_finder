import 'package:flutter/material.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_drawers.dart';
import 'hospital_registration_screen.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Admin Dash')),
      drawer: const AppDrawer(role: UserRole.superAdmin),
      body: GridView.count(
        padding: const EdgeInsets.all(24),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          _buildStatCard(context, 'Hospitals', '12', Icons.local_hospital, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HospitalRegistrationScreen(),
              ),
            );
          }),
          _buildStatCard(context, 'Total Users', '1.2k', Icons.people, () {}),
          _buildStatCard(context, 'Requests', '45', Icons.list_alt, () {}),
          _buildStatCard(context, 'System Info', 'Healthy', Icons.info, () {}),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.redAccent, size: 40),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
