import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pet_plus_ver01/Dat/Models/UserModels.dart';
import 'package:pet_plus_ver01/Dat/room_data_riverpod.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';
import 'package:pet_plus_ver01/Routes/CatOwnerSelector.dart';
import 'package:pet_plus_ver01/Routes/ListFoodSelector.dart';
import 'package:pet_plus_ver01/Screens/Widgets/BackButtonWidget.dart';
import 'package:pet_plus_ver01/Screens/Widgets/ConfirmationButton.dart';
import 'package:pet_plus_ver01/Screens/Widgets/ListButton.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextButtonWidget.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextFieldDefault.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextPasswordDefault.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Routes/IconSelector.dart';
import '../../Routes/ListRaceSelector.dart';

class Register_PetP2 extends StatefulWidget {
  @override
  State<Register_PetP2> createState() => _Register_PetP2State();
}

class _Register_PetP2State extends State<Register_PetP2> {
  final TextEditingController nameController = TextEditingController();
  Color colora = Colors.red;
  String selectedItem = '';

  String id = '22';
  var nList;
  List<String> nameList = [];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3));
    });

    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simula una operación asincrónica como una llamada a la red
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      print('Actualizacion: 2 carga');
    });
  }

  void _onItemSelected(String newItem) {
    setState(() {
      selectedItem = newItem;
    });
  }

  // Future<void> getId() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   id = prefs.getString('idS')!;
  //   print(id + '------');
  //   await fetchPets();
  // }

  Future<void> fetchPets(String id) async {
    final response = await http.get(Uri.parse(
        'https://eouww9yquk.execute-api.us-east-1.amazonaws.com/pets/get_pets_user?id=$id'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        nameList = ['-Seleccionar-']; // Reset the list with the default item
        for (var pet in data) {
          nameList.add(pet['id']);
        }
      });
    } else {
      print('Failed to load pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      String id = ref.read(userDataNotifierProvider).id!;
      fetchPets(id);
      return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
                ),

                Image.asset(
                  AssetPaths.getPath(10),
                  width: 100.0,
                  height: 100.0,
                ),

                const Padding(
                  padding: EdgeInsets.all(16.0),
                ),

                TextField_Default(
                  TextTf: 'Nombre',
                  ruta: 1,
                  controller:
                      nameController, // Asignar el controlador al TextField
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),

                //TextField_Default(TextTf: 'Alimento', ruta: 11,),

                List_Button_Widget(
                  ruta: 11, //lista: Cat_Owner_Selector,
                  lista: Food_Selector,
                  onItemSelected: _onItemSelected,
                  pathtype: 'FoodId',
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),

                List_Button_Widget(
                  ruta: 8, //lista: Cat_Owner_Selector,
                  lista: nameList,
                  onItemSelected: _onItemSelected,
                  pathtype: 'PetSelect',
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),

                /*TextField_Default(TextTf: 'Raza', ruta: 8,),
                  
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                  ),*/

                Confirmation_Button(
                  TextButton: 'Confirmar',
                  ruta: '/home',
                  additionalFunction: () {
                    // Acceder al valor del TextField
                    String petName = nameController.text;
                    ref
                        .read(machineDataNotifierProvider.notifier)
                        .setData(2, petName);
                    ref
                        .read(machineDataNotifierProvider.notifier)
                        .postMachine(context, ref);
                  },
                ),

                const TextButtonWidget(
                  texto: 'Cancelar',
                  color: Colors.red,
                  atras: 'atras',
                ),

                const Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 0.0),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
