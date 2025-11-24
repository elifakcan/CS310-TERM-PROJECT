import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPass = TextEditingController();
  final TextEditingController newPass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: AppColors.darkBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: oldPass,
                decoration: const InputDecoration(labelText: 'Old Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return null;
                },
              ),
              TextFormField(
                controller: newPass,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Minimum 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmPass,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value != newPass.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // === SAVE BUTTON ===
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBlue,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // BASİT POPUP
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Password changed successfully'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // popup kapanır
                                Navigator.pop(context); // settings-page'e geri döner
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
