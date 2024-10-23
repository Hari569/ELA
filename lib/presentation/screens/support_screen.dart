import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildContactOption(
            icon: Icons.email,
            title: 'Email Support',
            subtitle: 'support@elagarden.com',
            onTap: () => _launchEmail('support@elagarden.com'),
          ),
          _buildContactOption(
            icon: Icons.phone,
            title: 'Phone Support',
            subtitle: '+91 (800) 123-456',
            onTap: () => _launchPhoneCall('+91800123456'),
          ),
          _buildContactOption(
            icon: Icons.chat,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            onTap: () => _launchLiveChat(),
          ),
          _buildFAQSection(),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQSection() {
    return Card(
      child: ExpansionTile(
        title: const Text('Frequently Asked Questions'),
        children: [
          _buildFAQItem(
              'How do I track my order?', 'You can track your order by...'),
          _buildFAQItem(
              'What is your return policy?', 'Our return policy allows...'),
          _buildFAQItem('How do I care for my plants?',
              'To care for your plants, make sure to...'),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8.0),
          Text(answer),
          const Divider(),
        ],
      ),
    );
  }
}

void _launchEmail(String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: encodeQueryParameters(<String, String>{
      'subject': 'Support Request',
    }),
  );

  if (await canLaunch(emailLaunchUri.toString())) {
    await launch(emailLaunchUri.toString());
  } else {
    print('Could not launch $emailLaunchUri');
  }
}

void _launchPhoneCall(String phoneNumber) async {
  final Uri phoneLaunchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );

  if (await canLaunch(phoneLaunchUri.toString())) {
    await launch(phoneLaunchUri.toString());
  } else {
    print('Could not launch $phoneLaunchUri');
  }
}

void _launchLiveChat() async {
  const String liveChatUrl = 'https://elagarden.com/live-chat';
  if (await canLaunch(liveChatUrl)) {
    await launch(liveChatUrl);
  } else {
    print('Could not launch $liveChatUrl');
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
