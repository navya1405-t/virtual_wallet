import 'package:flutter/material.dart';

class RegisterLink extends StatelessWidget {
  final VoidCallback onRegister;
  const RegisterLink({super.key, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onRegister,
      child: const Text("Don't have an account? Register"),
    );
  }
}
