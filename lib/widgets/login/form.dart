// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../helpers/database.dart';
import '../../screens/home.dart';
import 'fields.dart';
import 'resetpasswordDialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const Color primary = Color.fromARGB(255, 196, 87, 154);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  bool _obscure = true;
  bool _loading = false;

  InputDecoration _inputDecoration({required String label, IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: primary) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    setState(() => _loading = true);

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final user = await _dbHelper.getLogin(username, password);
    if (user != null) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
      );
      return;
    }

    final exists = await _dbHelper.userExists(username);
    if (exists) {
      if (mounted) setState(() => _loading = false);
      final updated = await ResetPasswordDialog.show(
        context,
        username,
        _dbHelper,
      );
      if (updated == true && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
        );
      }
      return;
    }

    await _dbHelper.saveUser({'username': username, 'password': password});
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(username: username)),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Form(
          key: _formKey,
          child: LoginFields(
            usernameController: _usernameController,
            passwordController: _passwordController,
            obscure: _obscure,
            loading: _loading,
            inputDecorationBuilder: _inputDecoration,
            onToggleObscure: () => setState(() => _obscure = !_obscure),
            onSubmit: _login,
            onRegister: () {
              if (_usernameController.text.trim().isEmpty ||
                  _passwordController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enter username and password to register'),
                  ),
                );
                return;
              }
              _login();
            },
          ),
        ),
      ),
    );
  }
}
