import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  void _launchWebsite() async {
    final Uri url = Uri.parse('https://nadeerep07.github.io/Portfolio/');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'nadeerep43@gmail.com',
      query: Uri.encodeFull('subject=Bug Report - InvoZoyo'),
    );

    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch email');
    }
  }

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
            onTap: () => _launchWebsite(),
          ),
          const Divider(),
          ListTile(
            title: const Text('Support & Feedback'),
            tileColor: Colors.grey[200],
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report an Issue'),
            onTap: () => _launchEmail(),
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Give Feedback'),
            onTap: () => _launchEmail(),
          ),
        ],
      ),
    );
  }
}
