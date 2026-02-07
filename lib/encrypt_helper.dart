import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key; // Import for `debugPrint`

class EncryptionHelper {
  // Key and IV are defined as static and final to be initialized only once.
  // The key must be 32 bytes (256 bits) for AES-256.
  static final _key = Key.fromUtf8('my32lengthsupersecretnooneknows!');
  // IV must be 16 bytes (128 bits).
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  /// Encrypts a plain text string using AES-256 and returns a Base64 encoded string.
  static String encrypt(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  /// Decrypts a Base64 encoded string.
  ///
  /// Returns the decrypted string if successful.
  /// Returns an error message or a default value if decryption fails due to
  /// invalid Base64 format or other issues.
  static String decrypt(String encryptedText) {
    try {
      // The `decrypt64` method automatically handles Base64 decoding.
      // If `encryptedText` is not a valid Base64 string, this will throw a FormatException.
      return _encrypter.decrypt64(encryptedText, iv: _iv);
    } on FormatException catch (e) {
      // Log the error for debugging purposes.
      debugPrint('FormatException during decryption: $e');
      debugPrint('Invalid encrypted text was: $encryptedText');
      // Return a user-friendly error message or a default value.
      return '[Error: Invalid Password]';
    } catch (e) {
      // Catch any other potential decryption errors.
      debugPrint('General error during decryption: $e');
      return '[Error: Could not decrypt]';
    }
  }
}
