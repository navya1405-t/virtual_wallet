import 'package:flutter/material.dart';

typedef InputDecorationBuilder =
    InputDecoration Function({required String label, IconData? icon});

class LoginFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool loading;
  final VoidCallback onToggleObscure;
  final Future<void> Function() onSubmit;
  final VoidCallback onRegister;
  final InputDecorationBuilder inputDecorationBuilder;

  const LoginFields({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.obscure,
    required this.loading,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onRegister,
    required this.inputDecorationBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: usernameController,
          decoration: inputDecorationBuilder(
            label: 'Username',
            icon: Icons.person,
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter username' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: passwordController,
          obscureText: obscure,
          decoration:
              inputDecorationBuilder(
                label: 'Password',
                icon: Icons.lock,
              ).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: onToggleObscure,
                ),
              ),
          validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: loading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
