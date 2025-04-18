import 'package:flutter/material.dart';

import 'package:notes_app/components/keyboard_dismissible.dart';
import 'package:notes_app/components/loading_indicator.dart';
import 'package:notes_app/components/localized_wrapper.dart';
import 'package:notes_app/l10n/app_localizations.dart';
import 'package:notes_app/services/database_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return LocalizedWrapper(
      child: KeyboardDismissible(
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.signUp),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  _buildHeaderIcon(context),
                  const SizedBox(height: 32),
                  _buildNameField(l10n),
                  const SizedBox(height: 16),
                  _buildEmailField(l10n),
                  const SizedBox(height: 16),
                  _buildPasswordField(l10n),
                  const SizedBox(height: 24),
                  _buildSignupButton(l10n),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build the header icon
  Widget _buildHeaderIcon(BuildContext context) {
    return Icon(
      Icons.person_add_outlined,
      size: 80,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Build the name input field
  Widget _buildNameField(AppLocalizations l10n) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: l10n.name,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.person_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterName;
        }
        return null;
      },
    );
  }

  /// Build the email input field
  Widget _buildEmailField(AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: l10n.email,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterEmail;
        }
        return null;
      },
    );
  }

  /// Build the password input field
  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: l10n.password,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterPassword;
        }
        if (value.length < 6) {
          return l10n.passwordMinLength;
        }
        return null;
      },
    );
  }

  /// Build the signup button
  Widget _buildSignupButton(AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signup,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? const LoadingIndicator()
          : Text(l10n.signUp),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle signup process
  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final success = await _databaseHelper.registerUser(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (success && mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.accountCreated),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (mounted) {
          _showErrorSnackbar('Email already exists');
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}