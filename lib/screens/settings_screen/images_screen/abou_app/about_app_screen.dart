import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About App')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Information'),
            tileColor: Colors.grey[200],
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('App Name: InvoZoyo'),
          ),
          const ListTile(
            leading: Icon(Icons.update),
            title: Text('Version: 1.0.0'),
          ),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('Developer: Nadeer'),
          ),
          ListTile(
            leading: const Icon(Icons.web),
            title: const Text('Website'),
            subtitle: const Text('Visit our official website'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            title: const Text('Support & Feedback'),
            tileColor: Colors.grey[200],
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report an Issue'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Give Feedback'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
