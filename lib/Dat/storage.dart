import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pet_plus_ver01/Dat/user_data.dart';

class UserDataStorage {
  Future<void> saveUserDataStorage(UserData userData) async {
    const storage = FlutterSecureStorage();
    const key = 'userData';
    final value = jsonEncode(userData.toMap());

    await storage.write(key: key, value: value);
  }

  //! Restaurar desde flutter_secure_storage
  Future<UserData?> getUserDataStorage() async {
    const storage = FlutterSecureStorage();
    const key = 'userData';

    String? value = await storage.read(key: key);

    if (value == null) {
      return null;
    }
//
    //! Convertir el JSON a un mapa y luego crear una instancia de la clase
    Map<String, dynamic> map = jsonDecode(value);
    UserData user = UserData.fromMap(map);
    user.printUserData();
    return UserData.fromMap(map);
  }
}
