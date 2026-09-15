import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routes/route_names.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => context.push(RouteNames.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: const NetworkImage(
                'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=250&auto=format&fit=crop&q=80',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Jana Khaled',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Passionate reader • software engineering student'),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _Stat(label: 'Books Read', value: '14'),
                _Stat(label: 'Day Streak', value: '12'),
                _Stat(label: 'Pages', value: '3420'),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: const Text('Logout'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}
