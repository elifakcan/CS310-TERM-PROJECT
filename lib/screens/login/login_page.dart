import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_paddings.dart';
import '../../utils/app_text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('Please correct the highlighted fields.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.pushReplacementNamed(context, '/home');

    // Şimdilik sadece “Login successful” diyelim, başka sayfaya geçmiyoruz.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Successful'),
        content: Text('Welcome, ${_userCtrl.text}!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightCream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppPaddings.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Center(child: Text('FitSwipe', style: AppTextStyles.logo)),
                const SizedBox(height: 50),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _userCtrl,
                        decoration:
                        const InputDecoration(labelText: 'username'),
                        validator: (v) => v == null || v.isEmpty
                            ? 'Required'
                            : (v.length < 3 ? 'Min 3 chars' : null),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passCtrl,
                        decoration:
                        const InputDecoration(labelText: 'password'),
                        obscureText: true,
                        validator: (v) => v == null || v.isEmpty
                            ? 'Required'
                            : (v.length < 6 ? 'Min 6 chars' : null),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Log in'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
