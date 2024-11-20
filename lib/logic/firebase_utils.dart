import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUtils {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String getUserName() {
    final user = _auth.currentUser;
    return (user?.displayName ?? '').split(' ')[0];
  }

  static Map<String, dynamic> formatDatabaseSnapshot(Map<dynamic, dynamic> map) {
    Map<String, dynamic> formattedMap = {};
    map.forEach((key, value) {
      formattedMap[key.toString()] = value;
    });
    return formattedMap;
  }
}