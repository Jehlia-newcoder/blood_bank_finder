import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  final UserRole role;

  const AppDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              context.read<AuthProvider>().user?.name ?? 'User',
            ),
            accountEmail: Text(context.read<AuthProvider>().user?.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.redAccent),
            ),
            decoration: const BoxDecoration(color: Colors.redAccent),
          ),
          ..._buildMenuItems(context),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () {
              context.read<AuthProvider>().logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    switch (role) {
      case UserRole.superAdmin:
        return [
          _menuItem(Icons.dashboard, 'Admin Dashboard', () {}),
          _menuItem(Icons.local_hospital, 'Manage Hospitals', () {}),
          _menuItem(Icons.people, 'Manage Users', () {}),
        ];
      case UserRole.hospitalAdmin:
        return [
          _menuItem(Icons.dashboard, 'Hospital Dashboard', () {}),
          _menuItem(Icons.list_alt, 'Blood Requests', () {}),
          _menuItem(Icons.inventory, 'Inventory', () {}),
        ];
      case UserRole.regular:
        return [
          _menuItem(Icons.home, 'Home', () {}),
          _menuItem(Icons.person, 'Profile', () {}),
          _menuItem(Icons.notifications, 'Notifications', () {}),
          _menuItem(Icons.info_outline, 'About Us', () {}),
        ];
    }
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent),
      title: Text(title),
      onTap: onTap,
    );
  }
}
