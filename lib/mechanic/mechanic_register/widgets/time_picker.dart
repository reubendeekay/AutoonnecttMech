import 'package:flutter/material.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';
import 'package:intl/intl.dart' as intl;

class MyTimePicker extends StatefulWidget {
  const MyTimePicker({Key? key, this.onTimeChange}) : super(key: key);
  final Function(PickedTime opening, PickedTime closing)? onTimeChange;

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  final ClockTimeFormat _clockTimeFormat = ClockTimeFormat.twentyFourHours;

  PickedTime _inBedTime = PickedTime(h: 0, m: 0);
  PickedTime _outBedTime = PickedTime(h: 8, m: 0);
  PickedTime _intervalBedTime = PickedTime(h: 0, m: 0);

  double _sleepGoal = 8.0;
  bool _isSleepGoal = false;

  @override
  void initState() {
    super.initState();
    _isSleepGoal = (_sleepGoal >= 6.0) ? true : false;
    _intervalBedTime = formatIntervalTime(
        init: _inBedTime, end: _outBedTime, clockTimeFormat: _clockTimeFormat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141925),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Operating Time',
            style: TextStyle(
              color: Color(0xFF3CDAF7),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          TimePicker(
            initTime: _inBedTime,
            endTime: _outBedTime,
            height: 260.0,
            width: 260.0,
            onSelectionChange: _updateLabels,
            onSelectionEnd: (a, b) {
              widget.onTimeChange!(a, b);
            },
            primarySectors: _clockTimeFormat.value,
            secondarySectors: _clockTimeFormat.value * 2,
            decoration: TimePickerDecoration(
              baseColor: Color(0xFF1F2633),
              pickerBaseCirclePadding: 15.0,
              sweepDecoration: TimePickerSweepDecoration(
                pickerStrokeWidth: 30.0,
                pickerColor:
                    _isSleepGoal ? const Color(0xFF3CDAF7) : Colors.white,
                showConnector: true,
              ),
              initHandlerDecoration: TimePickerHandlerDecoration(
                color: const Color(0xFF141925),
                shape: BoxShape.circle,
                radius: 12.0,
                icon: const Icon(
                  Icons.open_in_browser_sharp,
                  size: 20.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              endHandlerDecoration: TimePickerHandlerDecoration(
                color: const Color(0xFF141925),
                shape: BoxShape.circle,
                radius: 12.0,
                icon: const Icon(
                  Icons.power_settings_new_outlined,
                  size: 20.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              primarySectorsDecoration: TimePickerSectorDecoration(
                color: Colors.white,
                width: 1.0,
                size: 4.0,
                radiusPadding: 25.0,
              ),
              secondarySectorsDecoration: TimePickerSectorDecoration(
                color: const Color(0xFF3CDAF7),
                width: 1.0,
                size: 2.0,
                radiusPadding: 25.0,
              ),
              clockNumberDecoration: TimePickerClockNumberDecoration(
                defaultTextColor: Colors.white,
                defaultFontSize: 12.0,
                scaleFactor: 2.0,
                showNumberIndicators: true,
                clockTimeFormat: _clockTimeFormat,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(62.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${intl.NumberFormat('00').format(_intervalBedTime.h)}Hr ${intl.NumberFormat('00').format(_intervalBedTime.m)}Min',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: _isSleepGoal
                            ? const Color(0xFF3CDAF7)
                            : Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: const Color(0xFF1F2633),
              child: const Text(
                'Confirm Time',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _timeWidget(
                'Opening',
                _inBedTime,
                const Icon(
                  Icons.open_in_browser_sharp,
                  size: 18.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
              _timeWidget(
                'Closing',
                _outBedTime,
                const Icon(
                  Icons.power_settings_new_outlined,
                  size: 18.0,
                  color: Color(0xFF3CDAF7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeWidget(String title, PickedTime time, Icon icon) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2633),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Text(
              '${intl.NumberFormat('00').format(time.h)}:${intl.NumberFormat('00').format(time.m)}',
              style: const TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF3CDAF7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            icon,
          ],
        ),
      ),
    );
  }

  void _updateLabels(PickedTime init, PickedTime end) {
    _inBedTime = init;
    _outBedTime = end;
    _intervalBedTime = formatIntervalTime(
        init: _inBedTime, end: _outBedTime, clockTimeFormat: _clockTimeFormat);
    _isSleepGoal = validateSleepGoal(
      inTime: init,
      outTime: end,
      sleepGoal: _sleepGoal,
      clockTimeFormat: _clockTimeFormat,
    );
    setState(() {});
  }
}
