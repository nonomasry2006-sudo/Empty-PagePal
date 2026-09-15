import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Welcome back',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue reading',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'Email',
                  controller: emailController,
                  hintText: 'you@example.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Password',
                  controller: passwordController,
                  hintText: '••••••••',
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  label: 'Login',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.go(RouteNames.home);
                    }
                  },
                ),
                const SizedBox(height: 18),
                Center(
                  child: TextButton(
                    onPressed: () => context.push(RouteNames.signup),
                    child: const Text('Create an account'),
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
