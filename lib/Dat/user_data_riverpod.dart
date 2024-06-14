import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pet_plus_ver01/Dat/storage.dart';
import 'package:pet_plus_ver01/Dat/user_data.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

final storageDataUser = UserDataStorage();
final userDataNotifierProvider =
    StateNotifierProvider<UserDataNotifier, UserData>(
        (ref) => UserDataNotifier());

class UserDataNotifier extends StateNotifier<UserData> {
  UserDataNotifier() : super(UserData());

  Future<void> inicializarDataStorage() async {
    try {
      UserData? userData = await storageDataUser.getUserDataStorage();

      if (userData != null) {
        logger.i('Data Local Encontrada');
        state = userData;
      } else {
        logger.w('Data Local no encontrada');
      }
    } catch (error) {
      logger.e('Error al obtener datos de usuario: $error');
    }
  }

  saveDataUserStorage() {
    storageDataUser.saveUserDataStorage(state);
  }

  late final Map<dynamic, void Function(dynamic)> _atributos = {
    1: (value) => state.id = value,
    2: (value) => state.name = value,
    3: (value) => state.lastname = value,
    4: (value) => state.user = value,
    5: (value) => state.password = value,
    6: (value) => state.email = value,
    7: (value) => state.pets = value,
  };

  void setData(int id, dynamic value) {
    final setter = _atributos[id];
    if (setter != null) {
      setter(value);
    } else {
      throw ArgumentError('ID de atributo no válido');
    }
  }

  Future<bool> login(BuildContext context) async {
    String url =
        'https://eouww9yquk.execute-api.us-east-1.amazonaws.com/login?user=${state.user}&password=${state.password}';
    logger.i(url);
    try {
      final response = await http
          .post(Uri.parse(url), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        logger.d(response.body);
        Map<String, dynamic> responseData = json.decode(response.body);
        Map<String, dynamic> userData = responseData['user'];
        state.id = userData['id'];
        state.name = userData['name'];
        state.lastname = userData['lastname'];
        state.email = userData['email'];
        fetchPets();
        saveDataUserStorage();
        state.printUserData();
        Navigator.pushNamed(context, '/home');
        return true;
      } else {
        logger.d(response.body);
        return false;
      }
    } catch (error) {
      logger.e(error.toString());
      return false;
    }
  }

  Future<void> fetchPets() async {
    final response = await http.get(Uri.parse(
        'https://eouww9yquk.execute-api.us-east-1.amazonaws.com/pets/get_pets_user?id=${state.id}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      var nameList = [
        {'id': '', 'name': '-Seleccionar-'}
      ]; // Reset the list with the default item
      for (var pet in data) {
        nameList.add({'id': pet['id'], 'name': pet['name']});
      }
      setData(7, nameList);
    } else {
      print('Failed to load pets');
    }
  }
}
