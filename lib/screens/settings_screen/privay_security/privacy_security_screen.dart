import 'package:flutter/material.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Security')),
      body: ListView(
        children: [
          ListTile(
              title: Text('Privacy Settings'), tileColor: Colors.grey[200]),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('App Lock'),
            subtitle: const Text('Enable PIN or biometric authentication'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Manage Permissions'),
            subtitle: const Text('Review granted permissions'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Clear Cache & Data'),
            subtitle: const Text('Free up storage space'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
              title: Text('Security Settings'), tileColor: Colors.grey[200]),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('Change Password'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.phonelink_lock),
            title: const Text('Two-Factor Authentication'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
