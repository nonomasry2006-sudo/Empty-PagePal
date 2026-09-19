import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glow_button.dart';
import '../../../../core/widgets/gradient_background.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Reader Name');
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => v == null || v.trim().length < 3
                          ? 'Name must be 3+ characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone (optional)',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return null;
                        final ok = RegExp(r'^[0-9+\-\s()]{7,}$').hasMatch(v);
                        return ok ? null : 'Invalid phone number';
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _bioCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GlowButton(
                      label: 'Save Changes',
                      icon: Icons.check_rounded,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}