import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../services/database_service.dart';
import '../widgets/super_admin_drawer.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final DatabaseService _db = DatabaseService();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      drawer: const SuperAdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: _db.streamAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }

                final users = snapshot.data!.where((u) {
                  final fullName = '${u.firstName} ${u.lastName}'.toLowerCase();
                  return fullName.contains(_searchQuery) ||
                      u.email.toLowerCase().contains(_searchQuery);
                }).toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    if (user.role == 'superadmin') {
                      return const SizedBox.shrink(); // Hide other superadmins
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user.isBanned
                            ? Colors.grey
                            : Colors.redAccent,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                      trailing: Switch(
                        value: !user.isBanned,
                        activeThumbColor: Colors.green,
                        onChanged: (active) async {
                          await _db.toggleUserBan(user.uid, !active);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  active ? 'User Unbanned' : 'User Banned',
                                ),
                                backgroundColor: active
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
