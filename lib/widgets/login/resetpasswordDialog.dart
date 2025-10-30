// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../helpers/database.dart';

class ResetPasswordDialog extends StatefulWidget {
  final String username;
  final DatabaseHelper dbHelper;

  const ResetPasswordDialog({
    super.key,
    required this.username,
    required this.dbHelper,
  });

  /// helper to show the dialog and return the bool result
  static Future<bool?> show(
    BuildContext context,
    String username,
    DatabaseHelper dbHelper,
  ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          ResetPasswordDialog(username: username, dbHelper: dbHelper),
    );
  }

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  late final TextEditingController _newCtrl;
  late final TextEditingController _confirmCtrl;
  final LocalAuthentication _auth = LocalAuthentication();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _newCtrl = TextEditingController();
    _confirmCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    final parentContext =
        context; // dialog context; use ScaffoldMessenger with ancestor Scaffold
    final newP = _newCtrl.text;
    final conf = _confirmCtrl.text;
    if (newP.isEmpty || conf.isEmpty) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(content: Text('Enter and confirm new password')),
      );
      return;
    }
    if (newP != conf) {
      ScaffoldMessenger.of(
        parentContext,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }

    setState(() => _submitting = true);

    bool authenticated = false;
    try {
      final bool canBiometric = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      if (!canBiometric && !isSupported) {
        setState(() => _submitting = false);
        ScaffoldMessenger.of(parentContext).showSnackBar(
          const SnackBar(
            content: Text('Device authentication not available on this device'),
          ),
        );
        return;
      }

      authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to confirm password change',
        options: const AuthenticationOptions(
          stickyAuth:
              true, // Optional: Keep authentication active if app goes to background
          biometricOnly: false, // Set to true to restrict to biometrics only
        ),
      );
    } on PlatformException catch (e) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(parentContext).showSnackBar(
        SnackBar(content: Text('Authentication error: ${e.message}')),
      );
      return;
    } catch (_) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(
        parentContext,
      ).showSnackBar(const SnackBar(content: Text('Authentication failed')));
      return;
    }

    if (!authenticated) {
      setState(() => _submitting = false);
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(
          content: Text('Device authentication failed or canceled'),
        ),
      );
      return;
    }

    final updated = await widget.dbHelper.updatePassword(widget.username, newP);
    if (!mounted) return;
    Navigator.of(context).pop(updated > 0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset Password'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Password for "${widget.username}" is incorrect. Enter a new password:',
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _newCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New password'),
          ),
          TextField(
            controller: _confirmCtrl,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm password'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _submitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitting ? null : _onConfirm,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirm'),
        ),
      ],
    );
  }
}
