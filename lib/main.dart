import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // Set debugShowCheckedModeBanner to false to remove the "Debug" banner (Question 4 from earlier)
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to get text input
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Keys for EncryptedSharedPreferences
  static const String _keyUsername = 'saved_username';
  static const String _keyPassword = 'saved_password';

  // Image source variable
  String imageSource = "assets/images/question-mark.png";

  @override
  void initState() {
    super.initState();
    // 1. Load credentials when the program starts
    _loadCredentials();
  }

  // --- Secure Storage and SnackBar Logic ---


   //Loads saved username and password from EncryptedSharedPreferences (via SharedPreferences).
   //If found, populates TextFields and shows a SnackBar.

  Future<void> _loadCredentials() async {
    try {
      // SharedPreferences uses secure storage when flutter_secure_storage is available
      final prefs = await SharedPreferences.getInstance();

      final String? savedUsername = prefs.getString(_keyUsername);
      final String? savedPassword = prefs.getString(_keyPassword);

      if (savedUsername != null && savedPassword != null) {
        // If saved strings are found, load them into the TextFields
        setState(() {
          loginController.text = savedUsername;
          passwordController.text = savedPassword;
        });

        // 4. Show a SnackBar that the previous credentials have been loaded
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Previous login name and password loaded from secure storage.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      // Handle potential decryption errors or storage issues
      print('Error loading saved data: $e');
    }
  }
   //Saves the current credentials to EncryptedSharedPreferences.

  Future<void> _saveCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, loginController.text);
    await prefs.setString(_keyPassword, passwordController.text);
    if (kDebugMode) {
      print('Credentials saved successfully.');
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login saved for next time!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

   // Clears all saved credentials from EncryptedSharedPreferences.
  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPassword);
    if (kDebugMode) {
      print('Saved credentials cleared.');
    }
  }


  // --- Login Button Handler ---

  void _login() {
    // 2. Show an AlertDialog asking whether the user wants to save credentials
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Save Credentials?'),
          content: const Text(
              'Would you like to save your username and password for your next session?'),
          actions: <Widget>[
            TextButton(
              // "No" button logic
              child: const Text('NO / CLEAR'),
              onPressed: () {
                _clearCredentials(); // Clear any existing data
                Navigator.of(context).pop();
                _performImageUpdateAndLogin(); // Proceed with login/image logic
              },
            ),
            TextButton(
              // "Yes" button logic
              child: const Text('YES / SAVE'),
              onPressed: () {
                _saveCredentials(); // Save the current text field contents
                Navigator.of(context).pop();
                _performImageUpdateAndLogin(); // Proceed with login/image logic
              },
            ),
          ],
        );
      },
    );
  }


   //Separated logic to run after the AlertDialog is closed.
  void _performImageUpdateAndLogin() {
    String password = passwordController.text;
    print("Enter password: $password");

    // Existing Image logic
    setState(() {
      if (password == "QWERTY123"){
        imageSource = "images/light-bulb.png";
      } else if (password != "ASDF") {
        imageSource = "images/stop-sign.png";
      }else {
        imageSource = "images/question-mark.png";
      }
    });

    // In a real app, successful login would navigate to a new screen here.
  }

  // --- Widget Build Method ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Login name TextField
            TextField(
              controller: loginController,
              decoration: const InputDecoration(
                labelText: 'Login name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password TextField with obscureText
            TextField(
              controller: passwordController,
              obscureText: true,  // hide password input
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Login button
            ElevatedButton(
              onPressed: _login, // Now calls the method that shows the AlertDialog
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),

            // Image with semantics for screen readers
            Semantics(
              label: 'Status Indicator',
              child: Image.asset(
                imageSource,
                width: 300,
                height: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}