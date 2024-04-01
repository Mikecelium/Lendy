// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:cloud_firestore/cloud_firestore.dart'; // For using Firestore













import "package:encrypt/encrypt.dart" as encrypt;

import 'package:bcrypt/bcrypt.dart';







import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:pointycastle/key_derivators/pbkdf2.dart';
import 'package:pointycastle/macs/hmac.dart';

import 'package:pointycastle/digests/sha256.dart';

class CryptoUtils {
  static encrypt.Key deriveKey(String password, String salt) {
    var pkcs = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pkcs.init(Pbkdf2Parameters(utf8.encode(salt), 1000, 32));
    Uint8List derivedKey = pkcs.process(utf8.encode(password));

    return encrypt.Key(derivedKey);
  }
}

// EncryptionHelper class remains largely the same, just ensure to use CryptoUtils.deriveKey for key derivation.




class EncryptionHelper {
  static String encryptData(String plainText, String password) {
    final salt = base64Url.encode(List<int>.generate(16, (i) => i)); // Example salt generation
    final key = CryptoUtils.deriveKey(password, salt);
    final iv = encrypt.IV.fromLength(16); // Initialization vector
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return "${encrypted.base64}::$salt"; // Store encrypted data and salt together
  }

  static String decryptData(String encryptedTextAndSalt, String password) {
    final parts = encryptedTextAndSalt.split('::');
    if (parts.length != 2) {
      throw Exception('Invalid encrypted data format');
    }
    final encryptedData = parts[0];
    final salt = parts[1];
    final key = CryptoUtils.deriveKey(password, salt);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedData), iv: iv);
    return decrypted;
  }
}


Future<void> storePaymentInfo(String userId, String paymentInfo, String password) async {
  final encryptedDataAndSalt = EncryptionHelper.encryptData(paymentInfo, password);
  FirebaseFirestore.instance.collection('users').doc(userId).set({
    'paymentData': encryptedDataAndSalt,
  });
}

Future<String> retrieveAndDecryptPaymentInfo(String userId, String password) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!doc.exists) {
    throw Exception('User not found');
  }
  final encryptedDataAndSalt = doc.data()!['paymentData'] as String;
  return EncryptionHelper.decryptData(encryptedDataAndSalt, password);
}





