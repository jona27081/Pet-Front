import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_plus_ver01/Dat/room_data_riverpod.dart';
import 'package:pet_plus_ver01/Screens/Widgets/BackButtonWidget.dart';
import 'package:pet_plus_ver01/Screens/Widgets/CameraButton.dart';
import 'package:pet_plus_ver01/Screens/Widgets/ConfirmationButton.dart';
import 'package:pet_plus_ver01/Screens/Widgets/ListButton.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextButtonWidget.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextFieldDefault.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TextPasswordDefault.dart';
import '../../Routes/IconSelector.dart';
import '../../Routes/ListRaceSelector.dart';

class Register_PetP1 extends StatelessWidget {
  // Controlador para el TextField
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 10.0, 250.0, 0.0),
                child: Back_Button_Widget(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 0.0),
              ),
              Image.asset(
                AssetPaths.getPath(13),
                width: 100.0,
                height: 100.0,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
              ),
              TextField_Default(
                TextTf: 'Código',
                ruta: 14,
                controller:
                    codeController, // Asignar el controlador al TextField
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              const Camera_Button(),
              const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
              ),
              Consumer(
                builder: (context, ref, child) => Confirmation_Button(
                  TextButton: 'Buscar',
                  ruta: '/RegisterPetP2',
                  additionalFunction: () {
                    String code = codeController.text;
                    ref
                        .read(machineDataNotifierProvider.notifier)
                        .setData(1, code);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
