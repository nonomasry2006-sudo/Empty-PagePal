import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glow_button.dart';
import '../../../../core/widgets/gradient_background.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('My Profile')),
      body: GradientBackground(
        showFireflies: false,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        child: const Icon(Icons.person, size: 48),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Reader Name',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'reader@example.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(
                            child: _StatTile(label: 'Books', value: '14'),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _StatTile(label: 'Hours', value: '82'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GlassCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit_outlined),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(RouteNames.editProfile),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.settings_outlined),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push(RouteNames.settings),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GlowButton(
                  label: 'Log Out',
                  icon: Icons.logout_rounded,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7F1D1D), Color(0xFFEF4444)],
                  ),
                  onPressed: () => context.go(RouteNames.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}