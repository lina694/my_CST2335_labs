import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  // Use FlutterSecureStorage instead of EncryptedSharedPreferences
  // Note: EncryptedSharedPreferences is Android-specific
  // FlutterSecureStorage works on both iOS and Android
  final _storage = const FlutterSecureStorage();

  // Keys for storage
  static const String _firstNameKey = 'firstName';
  static const String _lastNameKey = 'lastName';
  static const String _phoneNumberKey = 'phoneNumber';
  static const String _emailAddressKey = 'emailAddress';

  // Variables to store user data
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String emailAddress = '';

  /// Load data from EncryptedSharedPreferences
  Future<void> loadData() async {
    try {
      firstName = await _storage.read(key: _firstNameKey) ?? '';
      lastName = await _storage.read(key: _lastNameKey) ?? '';
      phoneNumber = await _storage.read(key: _phoneNumberKey) ?? '';
      emailAddress = await _storage.read(key: _emailAddressKey) ?? '';
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  /// Save data to EncryptedSharedPreferences
  Future<void> saveData() async {
    try {
      await _storage.write(key: _firstNameKey, value: firstName);
      await _storage.write(key: _lastNameKey, value: lastName);
      await _storage.write(key: _phoneNumberKey, value: phoneNumber);
      await _storage.write(key: _emailAddressKey, value: emailAddress);
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  /// Clear all data
  Future<void> clearData() async {
    try {
      await _storage.deleteAll();
      firstName = '';
      lastName = '';
      phoneNumber = '';
      emailAddress = '';
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}