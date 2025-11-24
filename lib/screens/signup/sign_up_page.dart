import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _usernameCtrl.dispose();
    _dobCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState!.validate()) {
      // ➜ Home sayfasına form verilerini arguments olarak gönder
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {
          'name'    : _nameCtrl.text.trim(),
          'surname' : _surnameCtrl.text.trim(),
          'username': _usernameCtrl.text.trim(),
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF143A66);
    const bgColor = Color(0xFFFFF9EF);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'FitSwipe',
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 36,
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Please enter your name'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _surnameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'surname',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Please enter your surname'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Please enter a username'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _dobCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today, color: mainColor),
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime(now.year - 18),
                        firstDate: DateTime(1900),
                        lastDate: now,
                      );
                      if (date != null) {
                        _dobCtrl.text =
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                        setState(() {});
                      }
                    },
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Please select your birth date'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    (v == null || v.length < 6) ? 'Min. 6 characters' : null,
                  ),
                  const SizedBox(height: 14),

                  TextFormField(
                    controller: _confirmPasswordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'confirm password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                    v != _passwordCtrl.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _onSignUp,
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      label: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

