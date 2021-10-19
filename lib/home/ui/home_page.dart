import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:upscale_help_app/home/data/dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = StreamController<Dashboard>();

  @override
  void initState() {
    Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        _controller.add(
          Dashboard(
            temperature: Random().nextInt(50),
            oxygen: Random().nextInt(100),
            beatRate: Random().nextInt(100),
          ),
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade900,
        title: const Center(
          child: Text('Monitoramento'),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade900,
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          StreamBuilder<Dashboard>(
            stream: _controller.stream,
            builder: (context, snapshot) {
              if (snapshot.data == null) return const SizedBox();
              return Column(
                children: [
                  Column(
                    children: [
                      RealTimeWidget(
                        title: 'Temperatura Corporal',
                        number: snapshot.data!.temperature,
                        color: getTemperatureColor(snapshot.data!.temperature),
                      ),
                      RealTimeWidget(
                        title: 'Oxigênio',
                        number: snapshot.data!.oxygen,
                        color: getOxigenColor(snapshot.data!.oxygen),
                      ),
                      RealTimeWidget(
                        title: 'Batimentos Cardíacos',
                        number: snapshot.data!.beatRate,
                        color: getBeatRateColor(snapshot.data!.beatRate),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
          Divider(
            color: Colors.blueGrey.shade400,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Proximas consultas',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: const [
                          CalendarItem(),
                          SizedBox(
                            height: 12,
                          ),
                          CalendarItem(),
                          SizedBox(
                            height: 12,
                          ),
                          CalendarItem(),
                          SizedBox(
                            height: 12,
                          ),
                          CalendarItem(),
                          SizedBox(
                            height: 12,
                          ),
                          CalendarItem(),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Color getTemperatureColor(int number) {
    if (number <= 0 || number < 30) return Colors.blue;
    if (number > 38 && number < 40) return Colors.yellow;
    if (number > 41) return Colors.red;
    return Colors.green;
  }

  Color getOxigenColor(int number) {
    if (number <= 0) return Colors.red.shade900;
    if (number > 0 && number < 50) return Colors.red;
    if (number > 51 && number < 69) return Colors.yellow;
    return Colors.green;
  }

  Color getBeatRateColor(int number) {
    if (number > 83 || number < 60) return Colors.red.shade900;
    if (number > 68 && number < 82) return Colors.yellow;
    return Colors.green;
  }
}

class CalendarItem extends StatelessWidget {
  const CalendarItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
        color: Colors.blueGrey.shade600,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 24,
            color: Colors.white,
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Dia 23/11/2021 às 17:00',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Médico : Victor Almeida',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RealTimeWidget extends StatelessWidget {
  final int number;
  final String title;
  final Color color;

  const RealTimeWidget({
    Key? key,
    required this.number,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
              color: color,
            ),
            height: 80,
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(fontSize: 26, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
