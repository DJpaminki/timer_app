import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class TimerWidgets extends StatefulWidget {
  const TimerWidgets({super.key});

  @override
  State<TimerWidgets> createState() => _TimerWidgetsState();
}

bool _enderData = false;
num _hour = 0;
num _minute = 0;
num _second = 0;
Timer? timer;
double _fontSizeCounter() {
  final double res = _enderData ? 80 : 25;
  return res;
}

class _TimerWidgetsState extends State<TimerWidgets> {
  void _start() {
    _enderData = true;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      num localSecond = _second;
      num localMinute = _minute;
      num localHour = _hour;

      if (localSecond == 0 && localMinute == 0 && localHour == 0) {
        _stop();
        _alarm();
      } else {
        if (localSecond == 0) {
          if (localMinute == 0) {
            localHour--;
            localMinute = 60;
            localSecond = 60;
          } else {
            localMinute--;
            localSecond = 60;
          }
        } else {
          localSecond--;
        }
      }
      setState(() {
        _second = localSecond;
        _minute = localMinute;
        _hour = localHour;
      });
    });
  }

  void _stop() {
    timer!.cancel();
    setState(() {
      _enderData = false;
    });
  }

  void _reset() {
    timer!.cancel();
    setState(() {
      _second = 0;
      _minute = 0;
      _hour = 0;

      _enderData = false;
    });
  }

  void _alarm() {
    FlutterRingtonePlayer.play(
      fromAsset: 'assets/sound/rington.wav',
      looping: true,
      volume: 0.7,
      asAlarm: true,
    );
    CoolAlert.show(
      context: context,
      onConfirmBtnTap: () {
        FlutterRingtonePlayer.stop();
        Navigator.pop(context);
      },
      type: CoolAlertType.info,
      text: "Время истекло",
      confirmBtnColor: Colors.black,
      confirmBtnText: "Выключить",
      title: "",
      backgroundColor: Colors.black,
      loopAnimation: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  disabledColor: Colors.white,
                  onPressed: _enderData
                      ? null
                      : () => setState(
                            () => (_hour < 0 || _hour >= 24)
                                ? _hour = 0
                                : _hour++,
                          ),
                  icon: const Icon(Icons.keyboard_arrow_up),
                  color: Colors.black,
                  iconSize: 70,
                ),
                Text(
                  (_hour < 10) ? '0$_hour' : '$_hour',
                  style: TextStyle(fontSize: _fontSizeCounter()),
                ),
                IconButton(
                  disabledColor: Colors.white,
                  onPressed: _enderData
                      ? null
                      : () => setState(
                            () => (_hour <= 0 || _hour >= 24)
                                ? _hour = 0
                                : _hour--,
                          ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: Colors.black,
                  iconSize: 70,
                ),
              ],
            ),
            Text(
              ':',
              style: TextStyle(
                fontSize: _fontSizeCounter(),
                color: _enderData ? Colors.black : Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  disabledColor: Colors.white,
                  onPressed: _enderData
                      ? null
                      : () => setState(
                            () => (_minute < 0 || _minute >= 60)
                                ? _minute = 0
                                : _minute++,
                          ),
                  icon: const Icon(Icons.keyboard_arrow_up),
                  color: Colors.black,
                  iconSize: 70,
                ),
                Text(
                  (_minute < 10) ? '0$_minute' : '$_minute',
                  style: TextStyle(fontSize: _fontSizeCounter()),
                ),
                IconButton(
                  disabledColor: Colors.white,
                  onPressed: _enderData
                      ? null
                      : () => setState(
                            () => (_minute <= 0 || _minute >= 60)
                                ? _minute = 0
                                : _minute--,
                          ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: Colors.black,
                  iconSize: 70,
                ),
              ],
            ),
            Text(
              ':',
              style: TextStyle(
                fontSize: _fontSizeCounter(),
                color: _enderData ? Colors.black : Colors.white,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  disabledColor: Colors.white,
                  onPressed: _enderData
                      ? null
                      : () => setState(
                            () => (_second < 0 || _second >= 60)
                                ? _second = 0
                                : _second++,
                          ),
                  icon: const Icon(Icons.keyboard_arrow_up),
                  color: Colors.black,
                  iconSize: 70,
                ),
                Text(
                  (_second < 10) ? '0$_second' : '$_second',
                  style: TextStyle(fontSize: _fontSizeCounter()),
                ),
                IconButton(
                  disabledColor: Colors.white,
                  onPressed: _enderData
                      ? null
                      : () => setState(
                            () => (_second <= 0 || _second >= 60)
                                ? _second = 0
                                : _second--,
                          ),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: Colors.black,
                  iconSize: 70,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 100,
              onPressed: () {
                _enderData ? _stop() : _start();
              },
              icon: const Icon(Icons.play_arrow_rounded),
            ),
            IconButton(
              iconSize: 40,
              onPressed: () {
                _reset();
              },
              icon: const Icon(Icons.delete_outline),
            ),
            IconButton(
              iconSize: 100,
              onPressed: () {
                setState(() {
                  _stop();
                });
              },
              icon: const Icon(Icons.stop_rounded),
            ),
          ],
        )
      ],
    );
  }
}
