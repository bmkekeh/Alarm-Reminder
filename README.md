# Alarm-Reminder App

An easy-to-use Flutter alarm app that lets you set multiple alarms, stop them, and snooze them with a single click. Perfect for reminders and daily routines.

## Features

- Set multiple alarms at different times.

- Stop an alarm immediately.

- Snooze an alarm for 5 minutes and updates time.

- Clear all alarms at once using the trash icon.

- Notifications with sound and vibration.

- Displays alarms in a dynamic, scrollable list.

## Requirements

- Flutter 3.0 or newer

- Dart 2.17 or newer

- iOS device/emulator

- Alarm audio file or any audio file

## Installation

 Clone the repository:

```bash
git clone https://github.com/bmkekeh/Alarm-Reminder.git
cd alarm_reminder
```


### Install dependencies:

```bash
flutter pub get
```

### Run the app on a simulator or device:

```bash
flutter run
```

## Usage

- Adding an Alarm

- Press the + floating button.

- Choose the time using the time picker.

- Confirm the alarm. A notification will appear and the alarm will be added to the list.

- Stopping an Alarm

- When an alarm rings, press Stop in the popup dialog, or tap the Stop icon next to the alarm in the list.

## Snoozing an Alarm

- When an alarm rings, press Snooze in the popup dialog, or tap the Snooze icon next to the alarm in the list.

- The alarm time will automatically move 5 minutes forward, and the new time replaces the old alarm.

## Clearing All Alarms

- Tap the trash icon in the AppBar to delete all alarms at once.


# Demo
Here is a Demo of running the code

https://github.com/user-attachments/assets/c4273e0a-89b3-4cb4-9bc4-098c5969cd3d


# Acknowledgements

- Flutter package for managing alarms.

- Built with Flutter and Material Design components.
