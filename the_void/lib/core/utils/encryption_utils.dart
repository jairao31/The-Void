import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

Key deriveKey(String password) {
  final passwordBytes = utf8.encode(password);
  final salt = utf8.encode('the_void_salt_v1');
  final pbkdf2 = Hmac(sha256, passwordBytes);
  var key = salt;
  for (int i = 0; i < 10000; i++) {
    key = pbkdf2.convert(key).bytes;
  }
  return Key(Uint8List.fromList(key.sublist(0, 32)));
}

Uint8List encryptBackup(String jsonString, String password) {
  final key = deriveKey(password);
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(jsonString, iv: iv);
  return Uint8List.fromList([...iv.bytes, ...encrypted.bytes]);
}

String decryptBackup(Uint8List encryptedBytes, String password) {
  final key = deriveKey(password);
  final iv = IV(Uint8List.fromList(encryptedBytes.sublist(0, 16)));
  final data = Encrypted(Uint8List.fromList(encryptedBytes.sublist(16)));
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  return encrypter.decrypt(data, iv: iv);
}
