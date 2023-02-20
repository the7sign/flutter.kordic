import 'dart:typed_data';
import "package:pointycastle/export.dart";
import 'package:convert/convert.dart';
import 'dart:convert';

class AesHelper {

  // final ivKey = "fedcba9876543210";
  // final String hashKey = "pixelscope||pixelcast||pxscope12";  // 32bytes
  // final hashKeyBytes = utf8.encode(hashKey);
  // final ivSpec = IVParameterSpec(utf8.encode(ivKey));
  // final secretKey = SecretKey(Uint8List.fromList(hashKeyBytes));

  static Uint8List decrypt(Uint8List ciphertext, Uint8List key, Uint8List iv) {
    CBCBlockCipher cipher = CBCBlockCipher(AESFastEngine());
    ParametersWithIV<KeyParameter> params = ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null> paddingParams = PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(params, null);
    PaddedBlockCipherImpl paddingCipher = PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(false, paddingParams);
    return paddingCipher.process(ciphertext);
  }

  static Uint8List generateKey(Uint8List salt, Uint8List passphrase){
    KeyDerivator derivator = PBKDF2KeyDerivator(HMac(SHA1Digest(), 64));
    Pbkdf2Parameters params = Pbkdf2Parameters(salt, 5, 16);
    derivator.init(params);
    return derivator.process(passphrase);
  }

}
