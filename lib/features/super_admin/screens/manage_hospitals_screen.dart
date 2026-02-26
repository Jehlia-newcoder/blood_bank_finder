import 'package:flutter/material.dart';
import '../../../models/hospital_model.dart';
import '../../../services/database_service.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/super_admin_drawer.dart';

class ManageHospitalsScreen extends StatefulWidget {
  const ManageHospitalsScreen({super.key});

  @override
  State<ManageHospitalsScreen> createState() => _ManageHospitalsScreenState();
}

class _ManageHospitalsScreenState extends State<ManageHospitalsScreen> {
  final DatabaseService _db = DatabaseService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Hospitals')),
      drawer: const SuperAdminDrawer(),
      body: StreamBuilder<List<HospitalModel>>(
        stream: _db.streamHospitals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hospitals registered.'));
          }

          final hospitals = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    hospital.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${hospital.city} | ${hospital.contactNumber}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _confirmDelete(hospital.id!, hospital.name),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddHospitalDialog,
        label: const Text('Register Hospital'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _confirmDelete(String id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Hospital'),
        content: Text('Are you sure you want to remove "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              await _db.deleteHospital(id);
              if (mounted) {
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('$name removed successfully')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddHospitalDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final cityController = TextEditingController();
    final addressController = TextEditingController();
    final contactController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Register New Hospital',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'Hospital Name',
                      controller: nameController,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Name is required' : null,
                    ),
                    CustomTextField(
                      label: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(v)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: 'City',
                      controller: cityController,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'City is required' : null,
                    ),
                    CustomTextField(
                      label: 'Address',
                      controller: addressController,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Address is required' : null,
                    ),
                    CustomTextField(
                      label: 'Contact Number',
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Contact is required';
                        }
                        if (v.length < 7) return 'Invalid contact number';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final newHospital = HospitalModel(
                      name: nameController.text,
                      email: emailController.text,
                      city: cityController.text,
                      address: addressController.text,
                      contactNumber: contactController.text,
                      latitude: 0,
                      longitude: 0,
                      availableBloodTypes: [],
                      isActive: true,
                      createdAt: DateTime.now(),
                    );

                    final navigator = Navigator.of(context);
                    await _db.addHospital(newHospital);
                    if (mounted) navigator.pop();
                  },
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
