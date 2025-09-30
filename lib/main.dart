import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Reminder',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AlarmHomePage(),
    );
  }
}

class AlarmHomePage extends StatefulWidget {
  const AlarmHomePage({super.key});

  @override
  State<AlarmHomePage> createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<AlarmHomePage> {
  @override
  void initState() {
    super.initState();

    // Listen for alarms when they ring
    Alarm.ringStream.stream.listen((alarmSettings) {
      showDialog(
        context: context,
        barrierDismissible: false, // force user to stop/snooze
        builder: (_) => AlertDialog(
          title: const Text("⏰ Alarm"),
          content: const Text("It's time!"),
          actions: [
            TextButton(
              onPressed: () async {
                await Alarm.stop(alarmSettings.id);
                Navigator.of(context).pop();
              },
              child: const Text("Stop"),
            ),
            TextButton(
              onPressed: () async {
                final snoozedTime = DateTime.now().add(
                  const Duration(minutes: 5),
                );

                // stop current alarm sound
                await Alarm.stop(alarmSettings.id);

                // copy the alarm and update only the dateTime
                final snoozeAlarm = alarmSettings.copyWith(
                  dateTime: snoozedTime,
                );

                // reschedule
                await Alarm.set(alarmSettings: snoozeAlarm);

                // update UI list
                setState(() {
                  final idx = _alarms.indexWhere(
                    (a) => a.id == alarmSettings.id,
                  );
                  if (idx >= 0) _alarms[idx] = snoozeAlarm;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Alarm snoozed for 5 minutes")),
                );
                Navigator.of(context).pop();
              },
              child: const Text("Snooze"),
            ),
          ],
        ),
      );
    });
  }

  final List<AlarmSettings> _alarms = [];
  int _nextId = 1; // unique id for each alarm

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      var alarmDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      // If time already passed today, schedule for tomorrow
      if (alarmDateTime.isBefore(now)) {
        alarmDateTime = alarmDateTime.add(const Duration(days: 1));
      }

      final alarmSettings = AlarmSettings(
        id: _nextId++,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        notificationTitle: 'Alarm',
        notificationBody: 'It’s time!',
        enableNotificationOnKill: true,
      );

      await Alarm.set(alarmSettings: alarmSettings);

      setState(() {
        _alarms.add(alarmSettings);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Alarm set for ${picked.format(context)}")),
      );
    }
  }

  Future<void> _clearAll() async {
    await Alarm.stopAll();
    setState(() {
      _alarms.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("All alarms cleared")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm Reminder"),
        actions: [
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(Icons.delete),
            tooltip: "Clear all alarms",
          ),
        ],
      ),
      body: _alarms.isEmpty
          ? const Center(child: Text("No alarms set"))
          : ListView.builder(
              itemCount: _alarms.length,
              itemBuilder: (context, index) {
                final alarm = _alarms[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.alarm),
                    title: Text(
                      "${alarm.dateTime.hour.toString().padLeft(2, '0')}:${alarm.dateTime.minute.toString().padLeft(2, '0')}",
                    ),
                    subtitle: Text(
                      "Scheduled on ${alarm.dateTime.toLocal().toString().split('.')[0]}",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.stop, color: Colors.red),
                          tooltip: "Stop alarm",
                          onPressed: () async {
                            await Alarm.stop(alarm.id);
                            setState(() {
                              _alarms.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Alarm stopped")),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.snooze, color: Colors.orange),
                          tooltip: "Snooze alarm (5 min)",
                          onPressed: () async {
                            final snoozeTime = alarm.dateTime.add(
                              const Duration(minutes: 5),
                            );

                            final snoozeAlarm = alarm.copyWith(
                              id: _nextId++,
                              dateTime: snoozeTime,
                            );

                            await Alarm.set(alarmSettings: snoozeAlarm);

                            setState(() {
                              _alarms[index] =
                                  snoozeAlarm; // replace with snoozed alarm
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Alarm snoozed for 5 min"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _pickTime,
        child: const Icon(Icons.add),
      ),
    );
  }
}
