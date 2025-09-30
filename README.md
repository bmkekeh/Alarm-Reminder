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

# How It Works (Code Overview)

Alarm Initialization:
The app initializes the alarm plugin on startup using await Alarm.init().

Adding Alarms:

_pickTime() shows a time picker and converts the selected time to DateTime.

Creates an AlarmSettings object and schedules it using Alarm.set().

Updates the _alarms list to display in the UI.

Alarm Ring Listener:

Listens to Alarm.ringStream.stream.

Shows a popup dialog with Stop and Snooze options when the alarm rings.

Stop Alarm:

Alarm.stop(alarm.id) stops the ringing sound.

Removes the alarm from the list.

Snooze Alarm:

Adds 5 minutes to the alarm time.

Stops the current alarm using Alarm.stop().

Reschedules the new snoozed alarm using Alarm.set().

Replaces the old alarm in the list with the new time.

Clear All:

Alarm.stopAll() stops all active alarms.

Clears the _alarms list from the UI.

# Demo



# Acknowledgements

- Flutter package for managing alarms.

- Built with Flutter and Material Design components.
