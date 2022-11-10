import 'dart:async';
import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int second = 0;
  num minuet = 0;
  num hour = 0;
  bool started = false;
  Timer? timer;
  List loops = [];
  String textSecond = '00';
  String textMinuet = '00';
  String textHour = '00';

  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  void reset() {
    timer!.cancel();
    setState(() {
      second = 0;
      minuet = 0;
      hour = 0;

      textSecond = "00";
      textMinuet = '00';
      textHour = '00';

      started = false;
    });
  }

  void appLoop() {
    final String loop = '$textHour:$textMinuet:$textSecond';
    setState(() {
      loops.add(loop);
    });
  }

  void start() {
    started = true;

    timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      double localSecond = second + 1;
      num localMinuet = minuet;
      num localHour = hour;

      if (localSecond > 99) {
        if (localMinuet > 99) {
          localHour++;
          localMinuet = 0;
        } else {
          localMinuet++;
          localSecond = 0;
        }
      }
      setState(() {
        second = localSecond.toInt();
        minuet = localMinuet;
        hour = localHour;

        textSecond = (second >= 10) ? '$second' : '0$second';
        textMinuet = (minuet >= 10) ? '$minuet' : '0$minuet';
        textHour = (hour >= 10) ? '$hour' : '0$hour';
      });
    });
  }

  void cleanList() {
    loops = [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$textHour:$textMinuet:$textSecond',
            style: const TextStyle(fontSize: 50),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black,
              ),
              height: 350,
              child: ListView.builder(
                itemCount: loops.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '#${index + 1}...............................................',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${loops[index]}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: 100,
                onPressed: () {
                  (!started) ? start() : stop();
                },
                icon: const Icon(Icons.play_arrow_rounded),
              ),
              IconButton(
                iconSize: 50,
                onPressed: () => appLoop(),
                icon: const Icon(Icons.flag_rounded),
              ),
              IconButton(
                iconSize: 100,
                onPressed: () => reset(),
                icon: const Icon(Icons.stop_rounded),
              ),
            ],
          ),
          IconButton(
            iconSize: 40,
            onPressed: () => cleanList(),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
