import 'package:flutter/material.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Settings')),
      body: GradientBackground(
        showFireflies: false,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile(
                      value: true,
                      onChanged: (_) {},
                      secondary: const Icon(Icons.notifications_outlined),
                      title: const Text('Push Notifications'),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      value: false,
                      onChanged: (_) {},
                      secondary: const Icon(Icons.alarm_outlined),
                      title: const Text('Daily Reading Reminder'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Other',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              GlassCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.cleaning_services_outlined),
                      title: const Text('Clear Cache'),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('About PagePal'),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'PagePal v1.0.0',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}