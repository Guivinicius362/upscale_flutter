// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:upscale_help_app/home/data/dashboard.dart';

class MQTTService {
  late MqttServerClient client;
  MQTTService();

  void init<T>(
    StreamController<Dashboard> controller,
    StreamController<bool> emergecyController,
  ) async {
    var rng = Random();
    MqttServerClient client = MqttServerClient.withPort(
        '73c9b9e3ef304ef1975e487d39a8be59.s1.eu.hivemq.cloud',
        'mobile ${rng.nextInt(100)}',
        8883);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.secure = true;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;

    final connMessage = MqttConnectMessage()
        .authenticateAs('melindroso', 'Melindroso20')
        .withWillTopic('randomtopic')
        .withWillMessage('connected')
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
      final String? message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (message != null && message.isNotEmpty) {
        final json = Map<String, dynamic>.from(jsonDecode(message));
        if (json['emergency'] != null && json['emergency'] as bool == true) {
          return emergecyController.add(true);
        }

        final dashboard = Dashboard.fromJson(json);
        return controller.add(dashboard);
      }
    });
    client.subscribe('vital_signs_2', MqttQos.exactlyOnce);
    client.subscribe('emergency', MqttQos.exactlyOnce);
  }

  // connection succeeded
  void onConnected() {
    print('Connected');
  }

// unconnected
  void onDisconnected() {
    print('Disconnected');
  }

// subscribe to topic succeeded
  void onSubscribed(String? topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String? topic) {
    print('Unsubscribed topic: $topic');
  }

// PING response received
  void pong() {
    print('Ping response client callback invoked');
  }
}
