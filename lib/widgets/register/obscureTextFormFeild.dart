import 'package:flutter/material.dart';

class ObscureTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final Color primaryColor;
  final String? Function(String?)? validator;

  const ObscureTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    required this.primaryColor,
    this.validator,
  });

  @override
  State<ObscureTextFormField> createState() => _ObscureTextFormFieldState();
}

class _ObscureTextFormFieldState extends State<ObscureTextFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: Icon(widget.prefixIcon, color: widget.primaryColor),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
            color: widget.primaryColor,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      obscureText: _obscure,
      validator: widget.validator,
      textInputAction: TextInputAction.next,
    );
  }
}
