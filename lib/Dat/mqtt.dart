import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

var logger = Logger();

class MQTT extends ChangeNotifier {
  final client = MqttServerClient('ws://74.208.107.159/mqtt', '8083');
  final String id;
  // ignore: non_constant_identifier_names
  final String id_machine;
  late StreamController<String> _statusMessageController;
  late StreamController<String> _foodLevelMessageController;
  late StreamController<String> _foodLevelEmptyMessageController;
  late StreamController<String> _timeMessageController;
  final builder = MqttClientPayloadBuilder();
  bool isConnected = false;

  Stream<String> get statusMessageStream => _statusMessageController.stream;
  Stream<String> get foodLevelMessageStream =>
      _foodLevelMessageController.stream;
  Stream<String> get foodLevelEmptyMessageStream =>
      _foodLevelEmptyMessageController.stream;
  Stream<String> get timeMessageStream => _timeMessageController.stream;

  MQTT(this.id, this.id_machine) {
    _initialize();
    _statusMessageController = StreamController<String>.broadcast();
    _foodLevelMessageController = StreamController<String>.broadcast();
    _foodLevelEmptyMessageController = StreamController<String>.broadcast();
    _timeMessageController = StreamController<String>.broadcast();
  }

  Future<void> _initialize() async {
    await _connectClient();
  }

  Future<void> _connectClient() async {
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.port = 8083;
    client.autoReconnect = false;
    client.useWebSocket = true;

    try {
      await client.connect();
    } catch (e) {
      logger.e('Error connecting client: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      logger.i('Client connected');
      isConnected = true;
      _subscribeToTopics();
    } else {
      logger.e(
          'Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>>? c) {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      final String topic = c[0].topic;

      _handleMessage(topic, payload);
    });
  }

  Future<void> _subscribeToTopics() async {
    if (isConnected) {
      client.subscribe('PetPlus/Status/$id/$id_machine', MqttQos.atLeastOnce);
      client.subscribe(
          'PetPlus/FoodLevel/$id/$id_machine', MqttQos.atLeastOnce);
      client.subscribe('PetPlus/Time/$id/$id_machine', MqttQos.atLeastOnce);
      client.subscribe(
          'PetPlus/FoodLevel/Empty/$id/$id_machine', MqttQos.exactlyOnce);
    } else {
      logger.e('Cannot subscribe, client is not connected');
    }
  }

  void publishMessage(String topic, String message) {
    if (isConnected) {
      builder.clear();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    } else {
      logger.e('Cannot publish, client is not connected');
    }
  }

  void onDisconnected() {
    logger.w('OnDisconnected client callback - Client disconnection');
    isConnected = false;
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      logger.i('OnDisconnected callback is solicited, this is correct');
    }
  }

  void onConnected() {
    logger.i('OnConnected client callback - Client connection was successful');
    isConnected = true;
    _subscribeToTopics();
  }

  void onSubscribed(String topic) {
    // logger.i('Subscription confirmed for topic $topic');
  }

  void _handleMessage(String topic, String message) {
    if (topic == 'PetPlus/Status/$id/$id_machine') {
      _statusMessageController.add(message);
    } else if (topic == 'PetPlus/FoodLevel/$id/$id_machine') {
      _foodLevelMessageController.add(message);
    } else if (topic == 'PetPlus/Time/$id/$id_machine') {
      _timeMessageController.add(message);
    } else if (topic == 'PetPlus/FoodLevel/Empty/12345') {
      _foodLevelEmptyMessageController.add(message);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _statusMessageController.close();
    _foodLevelEmptyMessageController.close();
    _foodLevelMessageController.close();
  }
}
