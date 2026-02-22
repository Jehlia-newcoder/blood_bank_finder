import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/app_drawers.dart';
import 'find_blood_bank_screen.dart';
import 'donate_blood_screen.dart';
import 'request_blood_screen.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Bank Finder')),
      drawer: const AppDrawer(role: UserRole.regular),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${context.watch<AuthProvider>().user?.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildActionCard(
              context,
              'Find Blood Banks',
              'Search for hospitals nearby',
              Icons.search,
              Colors.red[50]!,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FindBloodBankScreen(),
                ),
              ),
            ),
            _buildActionCard(
              context,
              'Donate Blood',
              'Schedule your next donation',
              Icons.volunteer_activism,
              Colors.red[100]!,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DonateBloodScreen(),
                ),
              ),
            ),
            _buildActionCard(
              context,
              'Request Blood',
              'Post an emergency request',
              Icons.emergency,
              Colors.red[200]!,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestBloodScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [color, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 48, color: Colors.redAccent),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }
}
