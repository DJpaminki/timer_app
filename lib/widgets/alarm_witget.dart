import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

List<Map<String, int>> alarmList = [];

class AlarmWidgets extends StatefulWidget {
  const AlarmWidgets({super.key});

  @override
  State<AlarmWidgets> createState() => _AlarmWidgetsState();
}

class _AlarmWidgetsState extends State<AlarmWidgets> {
  TimeOfDay _time = TimeOfDay.now();
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
      alarmList.add(
        {'hour': newTime.hour.toInt(), 'minuet': newTime.minute.toInt()},
      );
    });
  }

  void deleteAlarm(int index) {
    setState(() {
      alarmList.removeAt(index);
    });
  }

  void alarm() {
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
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(10, 100, 10, 0),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                showPicker(
                  is24HrFormat: true,
                  cancelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  cancelText: "Выити",
                  okStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  okText: "Добавить",
                  accentColor: Colors.black,
                  unselectedColor: Colors.black,
                  context: context,
                  value: _time,
                  onChange: onTimeChanged,
                ),
              );
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.grey.shade800),
              fixedSize: MaterialStateProperty.all(const Size(270, 70)),
              elevation: MaterialStateProperty.all(10),
              backgroundColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            child: const Text(
              "Добавить будильник",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          SizedBox(
            width: 600,
            height: 600,
            child: ListView.builder(
              itemCount: alarmList.length,
              itemBuilder: (context, index) => AlarmTimeWidgets(
                localTime: alarmList[index],
                alarmIndex: index,
                deleteFunc: (context) => deleteAlarm(index),
                alarmFnc: () => alarm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlarmTimeWidgets extends StatefulWidget {
  AlarmTimeWidgets({
    super.key,
    required this.localTime,
    required this.alarmIndex,
    required this.deleteFunc,
    required this.alarmFnc,
  });

  final int alarmIndex;
  final Map<String, int> localTime;
  Function(BuildContext)? deleteFunc;
  Function() alarmFnc;

  @override
  State<AlarmTimeWidgets> createState() => _AlarmTimeWidgetsState();
}

bool switchBool = true;
Timer? timer;

class _AlarmTimeWidgetsState extends State<AlarmTimeWidgets> {
  void isOn(bool value) {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      (value == true &&
              widget.localTime['hour']! == TimeOfDay.now().hour.toInt() &&
              widget.localTime['minuet']! == TimeOfDay.now().minute.toInt())
          ? widget.alarmFnc()
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 600,
            height: 1,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "${(widget.localTime['hour']! >= 10) ? '${widget.localTime['hour']}' : '0${widget.localTime['hour']}'} : ${(widget.localTime['minuet']! >= 10) ? '${widget.localTime['minuet']}' : '0${widget.localTime['minuet']}'}",
                style: const TextStyle(fontSize: 30),
              ),
              Row(
                children: [
                  Switch(
                    value: switchBool,
                    activeColor: Colors.black,
                    onChanged: (bool value) {
                      setState(() {
                        isOn(switchBool);
                        switchBool = value;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {
                      widget.deleteFunc!(context);
                    },
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.grey.shade800),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
