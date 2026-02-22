import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DonateBloodScreen extends StatefulWidget {
  const DonateBloodScreen({super.key});

  @override
  State<DonateBloodScreen> createState() => _DonateBloodScreenState();
}

class _DonateBloodScreenState extends State<DonateBloodScreen> {
  int _currentStep = 0;
  DateTime? _lastDonationDate;
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  final _illnessController = TextEditingController();
  String? _selectedHospital;
  bool _isSworn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donate Blood')),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() => _currentStep++);
          } else {
            _submitDonation();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        steps: [
          Step(
            title: const Text('Eligibility Check'),
            isActive: _currentStep >= 0,
            content: Column(
              children: [
                ListTile(
                  title: const Text('Last Donation Date'),
                  subtitle: Text(
                    _lastDonationDate == null
                        ? 'Not selected'
                        : DateFormat('yyyy-MM-dd').format(_lastDonationDate!),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) setState(() => _lastDonationDate = date);
                  },
                ),
                TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Medical History'),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Do you have any current illnesses or medical conditions? (e.g., Fever, Hypertension, Diabetes, etc.)',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _illnessController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Medical Conditions / Illnesses',
                    hintText: 'Enter "None" if healthy',
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Select Hospital'),
            isActive: _currentStep >= 2,
            content: DropdownButtonFormField<String>(
              value: _selectedHospital,
              decoration: const InputDecoration(labelText: 'Hospital'),
              items: [
                'St. Luke\'s Medical Center',
                'Cebu Doctors\' Hospital',
                'Davao Doctors Hospital',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedHospital = v),
            ),
          ),
          Step(
            title: const Text('Truth Declaration'),
            isActive: _currentStep >= 3,
            content: Column(
              children: [
                const Text(
                  'Safety is our priority. Please confirm the accuracy of your information.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  title: const Text(
                    'I solemnly swear that all information provided is true and correct to the best of my knowledge.',
                    style: TextStyle(fontSize: 13),
                  ),
                  activeColor: Colors.redAccent,
                  value: _isSworn,
                  onChanged: (v) => setState(() => _isSworn = v ?? false),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Confirmation'),
            isActive: _currentStep >= 4,
            state: _isSworn ? StepState.complete : StepState.disabled,
            content: Text(
              _isSworn
                  ? 'Please confirm that the information provided is correct. We will contact you shortly to schedule your appointment.'
                  : 'You must check the truth declaration in the previous step to proceed.',
              style: TextStyle(color: _isSworn ? Colors.black : Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _submitDonation() {
    if (!_isSworn) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Your donation request has been submitted.'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
