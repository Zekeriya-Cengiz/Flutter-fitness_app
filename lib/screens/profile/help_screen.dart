import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yardım'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFaqItem(
            context,
            question: 'Nasıl antrenman programı oluşturabilirim?',
            answer:
                'Antrenman sekmesine giderek istediğiniz antrenman türünü seçebilir ve programınızı oluşturabilirsiniz.',
          ),
          _buildFaqItem(
            context,
            question: 'İlerleme durumumu nasıl takip edebilirim?',
            answer:
                'Ana sayfada günlük hedeflerinizi ve istatistiklerinizi görüntüleyebilirsiniz.',
          ),
          _buildFaqItem(
            context,
            question: 'Bildirim ayarlarını nasıl değiştirebilirim?',
            answer:
                'Profil > Ayarlar > Bildirimler yolunu izleyerek bildirim tercihlerinizi düzenleyebilirsiniz.',
          ),
          _buildFaqItem(
            context,
            question: 'Kişisel bilgilerimi nasıl güncelleyebilirim?',
            answer:
                'Profil > Kişisel Bilgiler menüsünden bilgilerinizi güncelleyebilirsiniz.',
          ),
          const SizedBox(height: 32),
          const Text(
            'İletişim',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: 'destek@fitnessapp.com',
          ),
          _buildContactItem(
            icon: Icons.phone_outlined,
            title: 'Telefon',
            subtitle: '+90 555 123 4567',
          ),
          _buildContactItem(
            icon: Icons.web_outlined,
            title: 'Website',
            subtitle: 'www.fitnessapp.com',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
