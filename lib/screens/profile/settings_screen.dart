import 'package:flutter/material.dart';
import '../../services/database_helper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Genel',
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Bildirimler'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Bildirimleri aç/kapa
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language_outlined),
                title: const Text('Dil'),
                trailing: const Text('Türkçe'),
                onTap: () {
                  // TODO: Dil seçimi
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Uygulama',
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Hakkında'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Fitness App',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2024 Fitness App',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Gizlilik Politikası'),
                onTap: () {
                  // TODO: Gizlilik politikası sayfasına git
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Kullanım Koşulları'),
                onTap: () {
                  // TODO: Kullanım koşulları sayfasına git
                },
              ),
            ],
          ),
          _buildSection(
            title: 'Veri',
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Verileri Temizle'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Verileri Temizle'),
                      content: const Text(
                        'Tüm verileriniz silinecek. Bu işlem geri alınamaz. Devam etmek istiyor musunuz?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('İptal'),
                        ),
                        FilledButton(
                          onPressed: () async {
                            await DatabaseHelper.instance.resetDatabase();
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Veriler temizlendi'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: const Text('Temizle'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
