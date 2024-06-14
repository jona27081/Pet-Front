import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/LogIn.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/MainScreenU.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lateral_Menu extends StatefulWidget {
  //Function(String, String) onTextChanged;
  /*Lateral_Menu({
    required this.onTextChanged
    //super.key
    });*/

  @override
  State<Lateral_Menu> createState() => _Lateral_MenuState();
}

class _Lateral_MenuState extends State<Lateral_Menu> {
  String userN = 'TextUser';
  String emailN = 'test.user@testmail.com';
  List<String> listaS = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String user = ref.read(userDataNotifierProvider).user ?? "user";
        String email = ref.read(userDataNotifierProvider).email ?? "email";
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Row(children: <Widget>[
                  const Icon(
                    Icons.person_sharp,
                    color: Colors.black,
                    size: 60,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              user,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/EditAccount");
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.transparent),
                                elevation: MaterialStateProperty.all<double>(0),
                                shadowColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(0), // Sin bordes
                                  ),
                                ),
                              ),
                              child: Image.asset(
                                'assets/lapiz(1).png',
                                width: 24.0,
                                height: 24.0,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                ]),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('INICIO '),
                onTap: () => Navigator.pushNamed(context, "/home"),
              ),
              ListTile(
                leading: const Icon(Icons.pets_sharp),
                title: const Text('AÑADIR AMIGO'),
                onTap: () => Navigator.pushNamed(context, "/RegisterCat"),
              ),
              ListTile(
                leading: const Icon(Icons.sensors_sharp),
                title: const Text('REGISTRAR PET+'),
                onTap: () => Navigator.pushNamed(context, "/RegisterPetP1"),
              ),
              ListTile(
                leading: const Icon(Icons.logout_sharp),
                title: const Text('SALIR'),
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Log_In()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
