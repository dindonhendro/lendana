// encryption_util.dart
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionUtil {
  static final _keyString =
      'my32lengthsupersecretnooneknows1'; // 32-character key
  static final _key = encrypt.Key.fromUtf8(_keyString);
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  static String encryptValue(String value) {
    final encrypted = _encrypter.encrypt(value, iv: _iv);
    return encrypted.base64;
  }

  static String decryptValue(String encryptedValue) {
    final decrypted = _encrypter.decrypt64(encryptedValue, iv: _iv);
    return decrypted;
  }
}
