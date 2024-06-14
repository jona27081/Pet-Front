import 'package:logger/logger.dart';

class UserData {
  String? user;
  String? lastname;
  String? password;
  String? id;
  String? email;
  String? name;
  List<Map<String, String>>? pets; // Nueva propiedad para la lista de mascotas

  UserData({
    this.user,
    this.lastname,
    this.password,
    this.id,
    this.email,
    this.name,
    this.pets, // Inicializar nueva propiedad
  });

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      user: map['user'],
      lastname: map['lastname'],
      password: map['password'],
      id: map['id'],
      email: map['email'],
      name: map['name'],
      pets: map['pets'] != null
          ? List<Map<String, String>>.from(map['pets'])
          : null, // Asignar nueva propiedad
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'lastname': lastname,
      'password': password,
      'id': id,
      'email': email,
      'name': name,
      'pets': pets, // Incluir nueva propiedad
    };
  }

  void printUserData() {
    logger.d('User Data:');
    logger.d('user: $user');
    logger.d('lastname: $lastname');
    logger.d('password: $password');
    logger.d('id: $id');
    logger.d('email: $email');
    logger.d('name: $name');
    if (pets != null) {
      for (var pet in pets!) {
        logger.d('pet id: ${pet['id']}, pet name: ${pet['name']}');
      }
    }
  }
}

var logger = Logger();
