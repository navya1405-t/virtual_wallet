// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import '../widgets/login/form.dart';
import '../widgets/login/header.dart';

class loginScreen extends StatelessWidget {
  const loginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primary, const Color(0xFF56CCF2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  LoginHeader(),
                  SizedBox(height: 24),
                  LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
