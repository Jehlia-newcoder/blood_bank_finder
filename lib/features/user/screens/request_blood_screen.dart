import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class RequestBloodScreen extends StatefulWidget {
  const RequestBloodScreen({super.key});

  @override
  State<RequestBloodScreen> createState() => _RequestBloodScreenState();
}

class _RequestBloodScreenState extends State<RequestBloodScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSworn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Blood')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomTextField(
                label: 'Patient Name',
                prefixIcon: Icons.person_outline,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Blood Type Required',
                ),
                items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {},
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Quantity (Units)',
                keyboardType: TextInputType.number,
              ),
              const CustomTextField(
                label: 'Hospital Location',
                prefixIcon: Icons.location_on_outlined,
              ),
              const CustomTextField(
                label: 'Contact Details',
                prefixIcon: Icons.phone,
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Truth Declaration',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: Colors.redAccent,
                title: const Text(
                  'I solemnly swear that the information provided in this emergency request is true, accurate, and for a legitimate medical need.',
                  style: TextStyle(fontSize: 13),
                ),
                value: _isSworn,
                onChanged: (v) => setState(() => _isSworn = v ?? false),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Post Emergency Request',
                onPressed: _isSworn
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Request Posted Successfully'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    : null,
              ),
              if (!_isSworn)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    '* You must agree to the truth declaration to submit.',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
