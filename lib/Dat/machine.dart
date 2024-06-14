class Machine {
  final String code;
  final String idUser;
  final String statusMachine;
  final String id;
  final String idPet;
  final String name;
  final String activationTime;

  Machine({
    required this.code,
    required this.idUser,
    required this.statusMachine,
    required this.id,
    required this.idPet,
    required this.name,
    required this.activationTime,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      code: json['code'],
      idUser: json['id_user'],
      statusMachine: json['statusMachine'],
      id: json['id'],
      idPet: json['id_pet'],
      name: json['name'],
      activationTime: json['activationTime'],
    );
  }
}
