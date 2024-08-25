// constants.dart
import 'package:lendana5/encryption_util.dart';

const String API_TOKEN =
    '0d235dadc674344da8a2665ae5a4a0db43cebc632d94ca44cdd16ac1d38181951cd0cae558310eba9e368b8ff3c055405d3737495b27d93c24c11d797b17cb98e3e446f7a0f92bf1997b23bf74f3fd4edafc6c4eed784a86d7af86f27b62a18712e14f33c31c2accdff04b7d86ebe68990a834622c9b292464c4d7df059a7627';
final String encryptedToken = EncryptionUtil.encryptValue(API_TOKEN);

const String BASE_URL = 'http://10.0.2.2:1337';

const String API_TOKENP =
    '072f279b4e4c6a9234dd66b1a5341bde140ff4f0165da3ccca7117325421f9dae244d8c8733aeed7ca84790078c5fec5e8af071e2e0a1ae3653f51225cd9f67f728a4ba98d73cc40b455a971fb078f801ff0c18a41e30d0aed65269a999934f58d94aa94925397577ed22b5caa71bdb004bd85315530c42dfc2bf5de9a39da6d';

const String BASE_URLP = 'https://strap-do-r3lod.ondigitalocean.app';
