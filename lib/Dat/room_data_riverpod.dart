import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:pet_plus_ver01/Dat/machine_data.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';

var logger = Logger();
final machineDataNotifierProvider =
    StateNotifierProvider<MachineDataNotifier, MachineData>(
        (ref) => MachineDataNotifier());

class MachineDataNotifier extends StateNotifier<MachineData> {
  MachineDataNotifier() : super(MachineData());

  late final Map<dynamic, void Function(dynamic)> _atributos = {
    1: (value) => state.code = value,
    2: (value) => state.name = value,
    3: (value) => state.statusMachine = value,
    4: (value) => state.idPet = value,
    5: (value) => state.idUser = value,
    6: (value) => state.activationTime = value,
  };

  void setData(int id, dynamic value) {
    final setter = _atributos[id];
    if (setter != null) {
      setter(value);
    } else {
      throw ArgumentError('ID de atributo no válido');
    }
  }

  Future<bool> postMachine(BuildContext context, WidgetRef ref) async {
    String url =
        'https://eouww9yquk.execute-api.us-east-1.amazonaws.com/machines/add_machine';
    Map<String, dynamic> jsonT = {
      'code': state.code,
      'name': state.name,
      'statusMachine': "true",
      'id_user': ref.read(userDataNotifierProvider).id,
      'id_pet': state.idPet,
      'activationTime': "NO DEFINIDO"
    };

    String jsonStr = json.encode(jsonT);
    logger.d(jsonStr);
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'}, body: jsonStr);

      if (response.statusCode == 200) {
        logger.d(response.body);
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
}
