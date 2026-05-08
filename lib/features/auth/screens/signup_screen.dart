library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/location_picker.dart';
import 'landing_screen.dart';
import 'otp_screen.dart';


// - _signup()
// - _completeSignup()
// - PhLocationPicker()


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  //holder
  final Map<String, dynamic> _formData = {
    'gender': 'Male',
    'bloodGroup': 'A+',
    'islandGroup': null,
    'region': null,
    'city': null,
    'barangay': null,
  };

  /// validate, save, otp, navigate to otpscreen.
  void _signup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final auth = context.read<AuthProvider>();

      // 1. Send OTP first
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sending verification code...')),
      );

      final error = await auth.sendOtp(_formData['email']);

      if (!mounted) return;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
        return;
      }

      // 2. Navigate to OTP Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            email: _formData['email'],
            onVerified: _completeSignup,
          ),
        ),
      );
    }
  }

  void _completeSignup() async {
    final auth = context.read<AuthProvider>();
    final error = await auth.signup(_formData, _formData['password']);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    // Go to LandingScreen as requested ("after login/signout")
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // input data
              Text(
                'Personal Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'First Name',
                prefixIcon: Icons.person_outline,
                onSaved: (v) => _formData['firstName'] = v,
              ),
              CustomTextField(
                label: 'Last Name',
                prefixIcon: Icons.person_outline,
                onSaved: (v) => _formData['lastName'] = v,
              ),
              CustomTextField(
                label: 'Mobile',
                prefixIcon: Icons.phone_android,
                keyboardType: TextInputType.phone,
                onSaved: (v) => _formData['mobile'] = v,
              ),
              _buildDropdown('Gender', ['Male', 'Female', 'Other'], 'gender'),
              _buildDropdown('Blood Group', [
                'A+',
                'A-',
                'B+',
                'B-',
                'O+',
                'O-',
                'AB+',
                'AB-',
              ], 'bloodGroup'),

              const SizedBox(height: 16),
              // location
              Text(
                'Location Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              // mopili og location. island, region, city, barangay.
              PhLocationPicker(
                onLocationChanged: (island, region, city, barangay) {
                  _formData['islandGroup'] = island;
                  _formData['region'] = region;
                  _formData['city'] = city;
                  _formData['barangay'] = barangay;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Street Address / House No.',
                prefixIcon: Icons.home_outlined,
                onSaved: (v) => _formData['address'] = v,
              ),

              const SizedBox(height: 16),
              // email og password
              Text(
                'Account Credentials',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) => _formData['email'] = v?.trim(),
              ),
              CustomTextField(
                label: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
                onSaved: (v) => _formData['password'] = v?.trim(),
              ),
              const SizedBox(height: 32),
              // pagclick sa signup button mogamit sa _signup method.
              Consumer<AuthProvider>(
                builder: (context, auth, _) => CustomButton(
                  label: 'Sign Up',
                  isLoading: auth.isLoading,
                  onPressed: _signup,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  //reusable. gigamit nga dropdown sa gender og bloodgroup
  Widget _buildDropdown(String label, List<String> items, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        initialValue: _formData[key],
        decoration: InputDecoration(labelText: label),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _formData[key] = v),
      ),
    );
  }
}
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// 
// METHODS EXPLANATION (CASUAL BISAYA):
// - _signup(): Mao ni ang magsugod sa pag-register. I-check niya kung kompleto ba imong info, i-save sa memory, ug mag-send og verification code sa imong email para siguro gyud.
// - _completeSignup(): Human nimo ma-verify imong email gamit ang OTP, kani nga method ang mo-create gyud sa imong account sa database ug mo-redirect nimo sa Landing Screen.
// - build(): Mao ni ang nag-drawing sa tibuok registration form—apil na ang Personal Info, Location Details, ug imong Account Credentials.
// - _buildDropdown(): Usa ka reusable widget para sa mga dropdown choices para dili na sige og balik-balik og code para sa Gender ug Blood Group.