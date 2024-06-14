import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_plus_ver01/Dat/machine.dart';
import 'package:pet_plus_ver01/Dat/mqtt.dart';
import 'package:pet_plus_ver01/Dat/user_data_riverpod.dart';
import 'package:pet_plus_ver01/Screens/Widgets/TimeWidget.dart';

// ignore: must_be_immutable
class ServiceCard extends StatefulWidget {
  final IconData icon;
  bool state;
  final int availability;
  final Machine machine;
  final double iconSize;
  final String petname;

  ServiceCard({
    super.key,
    required this.machine,
    required this.icon,
    required this.state,
    required this.availability,
    required this.petname,
    this.iconSize = 40,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String clockT = 'No disponible';

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        String id = ref.read(userDataNotifierProvider).id!;
        final mqtt = MQTT(id, widget.machine.code);
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          StreamBuilder<String>(
                            stream: mqtt.statusMessageStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &
                                  (snapshot.data == "APAGADO")) {
                                return IconButton(
                                  icon: Icon(
                                    widget.icon,
                                    color: Colors.red,
                                    size: widget.iconSize,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.state = !widget.state;
                                      mqtt.publishMessage(
                                          'PetPlus/OnOff/${widget.machine.code}',
                                          widget.state.toString());
                                    });
                                  },
                                );
                              } else {
                                return IconButton(
                                  icon: Icon(
                                    widget.icon,
                                    color: Colors.blue,
                                    size: widget.iconSize,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      widget.state = !widget.state;
                                      mqtt.publishMessage(
                                          'PetPlus/OnOff/${widget.machine.code}',
                                          widget.state.toString());
                                    });
                                  },
                                );
                              }
                            },
                          ),
                          StreamBuilder<String>(
                            stream: mqtt.statusMessageStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &
                                  (snapshot.data == "APAGADO")) {
                                return const Text(
                                  'Apagado',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 5, 2, 2),
                                  ),
                                );
                              } else {
                                return const Text(
                                  'Encendido',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 5, 2, 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                widget.machine.code,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 5, 2, 2),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.autorenew),
                                onPressed: () async {
                                  Map<String, dynamic> jsonMap = {
                                    "user": widget.machine.idUser,
                                    "id_race": widget.machine.idPet,
                                    "id_food": widget.machine.id
                                  };
                                  String jsonString = jsonEncode(jsonMap);
                                  mqtt.publishMessage(
                                      'PetPlus/Configuration/${widget.machine.code}',
                                      jsonString);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () async {
                                  Navigator.pushNamed(
                                      context, "/RegisterPetP1");
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Disponible: ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                              StreamBuilder<String>(
                                stream: mqtt.foodLevelMessageStream,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      '${snapshot.data}g',
                                      style: const TextStyle(
                                        fontSize: 22,
                                        color:
                                            Color.fromARGB(255, 63, 209, 148),
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black,
                                            offset: Offset(1, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const Text('Sin conexion');
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Time_Widget(
                        onTimeSelected: (TimeOfDay time) {
                          setState(() {
                            clockT = time.format(context);
                            String formattedTime = formatTime(clockT);
                            mqtt.publishMessage(
                                'PetPlus/Time/${widget.machine.code}',
                                formattedTime);
                          });
                        },
                      ),
                      const Text(
                        'Próxima ronda: ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      StreamBuilder<String>(
                        stream: mqtt.timeMessageStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData &
                              (snapshot.data != "NO ESPECIFICADO")) {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(255, 63, 209, 148),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Text(
                              widget.machine.activationTime,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Color.fromARGB(255, 63, 209, 148),
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.machine.idPet,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFecd391),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/gato.png',
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String formatTime(String timeString) {
  // Separar la hora y el período (AM/PM)
  List<String> parts = timeString.split(' ');
  String timePart = parts[0];
  String periodPart = parts[1];

  // Separar horas y minutos
  List<String> timeComponents = timePart.split(':');
  int hour = int.parse(timeComponents[0]);
  String minute = timeComponents[1];

  // Convertir a formato 24 horas
  if (periodPart == 'PM' && hour != 12) {
    hour += 12;
  } else if (periodPart == 'AM' && hour == 12) {
    hour = 0;
  }

  // Formatear la hora y los minutos en HH:mm
  String hourStr = hour.toString().padLeft(2, '0');
  String formattedTime = '$hourStr:$minute';

  return formattedTime;
}
