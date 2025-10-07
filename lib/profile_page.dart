import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user_repository.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final UserRepository repository;

  const ProfilePage({
    super.key,
    required this.username,
    required this.repository,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with data from repository
    _firstNameController = TextEditingController(text: widget.repository.firstName);
    _lastNameController = TextEditingController(text: widget.repository.lastName);
    _phoneController = TextEditingController(text: widget.repository.phoneNumber);
    _emailController = TextEditingController(text: widget.repository.emailAddress);

    // Add listeners to save data when text changes
    _firstNameController.addListener(() {
      widget.repository.firstName = _firstNameController.text;
      widget.repository.saveData();
    });

    _lastNameController.addListener(() {
      widget.repository.lastName = _lastNameController.text;
      widget.repository.saveData();
    });

    _phoneController.addListener(() {
      widget.repository.phoneNumber = _phoneController.text;
      widget.repository.saveData();
    });

    _emailController.addListener(() {
      widget.repository.emailAddress = _emailController.text;
      widget.repository.saveData();
    });

    // Show welcome back snackbar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome Back ${widget.username}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> _launchURL(String url, String urlType) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        _showUnsupportedDialog(urlType);
      }
    }
  }

  void _showUnsupportedDialog(String urlType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Not Supported'),
          content: Text('$urlType is not supported on this device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall() {
    String phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      _launchURL('tel:$phone', 'Phone calls');
    }
  }

  void _sendSMS() {
    String phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      _launchURL('sms:$phone', 'SMS messaging');
    }
  }

  void _sendEmail() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty) {
      _launchURL('mailto:$email', 'Email');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Text(
              'Welcome Back ${widget.username}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // First Name
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Last Name
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number with buttons
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _makePhoneCall,
                  child: const Icon(Icons.phone),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendSMS,
                  child: const Icon(Icons.sms),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email Address with button
            Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendEmail,
                  child: const Icon(Icons.mail),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
