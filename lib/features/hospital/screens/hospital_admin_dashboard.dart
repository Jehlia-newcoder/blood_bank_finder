import 'package:flutter/material.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_drawers.dart';
import 'blood_requests_list_screen.dart';

class HospitalAdminDashboard extends StatelessWidget {
  const HospitalAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hospital Admin Dash')),
      drawer: const AppDrawer(role: UserRole.hospitalAdmin),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildQuickStat(context, 'Pending Requests', '8', Colors.orange),
            const SizedBox(height: 20),
            _buildQuickStat(
              context,
              'Low Stock types',
              '2 (A-, O-)',
              Colors.redAccent,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BloodRequestsListScreen(),
                ),
              ),
              icon: const Icon(Icons.list),
              label: const Text('View All Requests'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
