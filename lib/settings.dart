import 'package:flutter/material.dart';

// Halaman Pengaturan
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'Indonesia';

  void _chooseLanguage() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Bahasa'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'Indonesia'),
            child: const Text('Indonesia'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context, 'English'),
            child: const Text('English'),
          ),
        ],
      ),
    );

    if (selected != null) {
      setState(() => _language = selected);
    }
  }

  void _resetSettings() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Pengaturan'),
        content: const Text('Kembalikan semua pengaturan ke default?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications = true;
                _darkMode = false;
                _language = 'Indonesia';
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Terima notifikasi promosi dan pembaruan'),
            value: _notifications,
            activeColor: Colors.blue[700],
            onChanged: (v) => setState(() => _notifications = v),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Gunakan tema gelap'),
            value: _darkMode,
            activeColor: Colors.blue[700],
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: Text(_language),
            onTap: _chooseLanguage,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'GoTour',
              applicationVersion: '1.0.0',
              children: const [Text('Aplikasi GoTour - demo tugas')],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _resetSettings,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reset Pengaturan'),
          ),
        ],
      ),
    );
  }
}
