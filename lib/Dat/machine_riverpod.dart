import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pet_plus_ver01/Dat/machine.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';

final machineListProvider = StateProvider<List<Machine>>((ref) => []);

Future<void> fetchMachines(WidgetRef ref) async {
  print("1");
  String id = ref.read(userDataNotifierProvider).id ?? "1";

  final response = await http.get(Uri.parse(
      'https://eouww9yquk.execute-api.us-east-1.amazonaws.com/machines/get_machines_user?id=$id'));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    final List<Machine> machines =
        data.map((json) => Machine.fromJson(json)).toList();
    ref.read(machineListProvider.notifier).state = machines;
  } else {
    print('Failed to load machines');
  }
}
