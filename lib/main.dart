import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';
import 'package:pet_plus_ver01/Screens/FirstTime/MainScreen.dart';
import 'package:pet_plus_ver01/Screens/FirstTime/TutorialScreen01.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/CreateAccount.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/DeleteAccount.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/EditAccount.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/EditPetP.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/LogIn.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/MainScreenU.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/RegisterCat.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/RegisterPetP1.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/RegisterPetP2.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/Register_1st_Cat.dart';
import 'package:pet_plus_ver01/Screens/UserScreens/home.dart';
import 'package:pet_plus_ver01/Screens/Widgets/ClockWidget.dart';
import 'package:pet_plus_ver01/Screens/Widgets/SuccessNotification.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TimeWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasData = prefs.containsKey('usuarioS');

  runApp(
    ProviderScope(
      child: MyApp(hasData: hasData),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool hasData;
  MyApp({required this.hasData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userDataNotifierProvider.notifier).inicializarDataStorage();
    return MaterialApp(
      routes: {
        '/MainScreen': (context) => Main_Screen(),
        '/TutorialScreen01': (context) => Tutorial_Screen01(),
        '/MainScreenU': (context) => Main_ScreenU(),
        '/CreateAccount': (context) => Create_Account(),
        '/LogIn': (context) => Log_In(),
        '/EditAccount': (context) => Edit_Account(),
        '/RegisterCat': (context) => Register_Cat(),
        '/Register_1st_Cat': (context) => Register_1st_Cat(),
        '/RegisterPetP1': (context) => Register_PetP1(),
        '/RegisterPetP2': (context) => Register_PetP2(),
        '/EditPetP': (context) => Edit_PetP(),
        '/home': (context) => home(),
        '/ClockWidget': (context) => Clock_Widget(),
        '/TimeWidget': (context) => Time_Widget(),
        '/DeleteAccount': (context) => Delete_Account(),
      },
      initialRoute: hasData ? '/MainScreenU' : '/MainScreen',
      title: 'Pet+ Demo',
      debugShowCheckedModeBanner: false,
    );
  }
}
