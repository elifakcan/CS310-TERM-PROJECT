import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../routes/app_routes.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    oldPass.dispose();
    newPass.dispose();
    confirmPass.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final startTime = DateTime.now();
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    
    await authProvider.changePassword(
      oldPass.text.trim(),
      newPass.text.trim(),
    );

    // En az 1 saniye loading göster
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed.inMilliseconds < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - elapsed.inMilliseconds));
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Check error after operation
    final error = authProvider.error;
    
    if (error != null && error.isNotEmpty) {
      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(error),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // Success - show success dialog and navigate to welcome/login
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Password changed successfully. You will be logged out. Please login again with your new password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close change password page
                  // Navigate to welcome/login page (AuthGate will handle this)
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.welcome,
                    (route) => false,
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isLoading ? null : _handleChangePassword,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.onPrimary,
                            ),
                            ),
                        )
                      : const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
