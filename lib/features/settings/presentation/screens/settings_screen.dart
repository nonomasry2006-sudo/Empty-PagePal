import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            value: darkMode,
            title: const Text('Dark mode'),
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
            },
          ),
          SwitchListTile(
            value: notifications,
            title: const Text('Notifications'),
            onChanged: (value) {
              setState(() {
                notifications = value;
              });
            },
          ),
          const ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Language'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About app'),
            trailing: Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {},
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
