import 'package:flutter/material.dart';
import 'package:zoyo_bathware/screens/settings_screen/images_screen/Image_manager_screen.dart';
import 'package:zoyo_bathware/screens/settings_screen/about_app/about_app_screen.dart';
import 'package:zoyo_bathware/screens/settings_screen/privay_security/privacy_security_screen.dart';
import 'package:zoyo_bathware/services/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            title: Text('General'),
            tileColor: AppColors.headingColor,
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Manage Home Images'),
            subtitle: const Text('Add or remove images for the carousel'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ImageManagerScreen()),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Account'),
            tileColor: AppColors.headingColor,
          ),
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('Profile'),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Privacy & Security'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacySecurityScreen()));
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('About'),
            tileColor: AppColors.headingColor,
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About App'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutAppScreen()));
            },
          ),
        ],
      ),
    );
  }
}
