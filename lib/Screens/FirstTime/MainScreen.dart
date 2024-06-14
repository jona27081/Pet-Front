import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextFieldDefault.dart';
//import 'package:pet_plus_v01/Widgets/InitialButton.dart';
import '../Widgets/InitialButton.dart';

class Main_Screen extends StatelessWidget {
  String TextButton = '¡Empezar ahora!';
  Color ButtonColor = const Color(0xFFcae0c8);
  Color TextColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //SizedBox(height: 25.0),
          const Spacer(
            flex: 1,
          ),
          const Image(image: AssetImage('assets/image-removebg-preview.png')),

          const Text(
            'PET+',
            style: TextStyle(fontSize: 20.0),
          ),
          const Spacer(
            flex: 1,
          ),
          //SizedBox(height: 175.0),
          Consumer(
            builder: (context, ref, child) {
              String? id = ref.watch(userDataNotifierProvider).id;
              return Initial_Button(
                  TextButton: (id != null) ? 'Ver mi hogar' : '¡Empezar ahora!',
                  ruta: (id != null) ? '/home' : '/CreateAccount');
            },
          ),

          const SizedBox(height: 50),
        ],
      ),
    ));
  }
}
