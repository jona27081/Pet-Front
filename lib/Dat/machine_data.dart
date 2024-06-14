import 'package:logger/logger.dart';

class MachineData {
  String? code;
  String? name;
  bool? statusMachine;
  String? idUser;
  String? idPet;
  String? activationTime;

  MachineData({
    this.code,
    this.name,
    this.statusMachine,
    this.idUser,
    this.idPet,
    this.activationTime,
  });

  factory MachineData.fromMap(Map<String, dynamic> map) {
    return MachineData(
      code: map['code'],
      name: map['name'],
      statusMachine: map['statusMachine'],
      idUser: map['id_user'],
      idPet: map['id_pet'],
      activationTime: map['activationTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'statusMachine': statusMachine,
      'id_user': idUser,
      'id_pet': idPet,
      'activationTime': activationTime,
    };
  }

  void printRoomData() {
    logger.d('Room Data:');
    logger.d('code: $code');
    logger.d('name: $name');
    logger.d('statusMachine: $statusMachine');
    logger.d('id_user: $idUser');
    logger.d('id_pet: $idPet');
    logger.d('activationTime: $activationTime');
  }
}

var logger = Logger();
