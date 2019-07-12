# flutter_mplat_ttt

A multi-platform Flutter sample game of tic-tac-toe.

## Getting Started

```shell
$ flutter run -d iphone   # or whatever matches your iOS simulator
$ flutter run -d android # or whatever matches your Android emulator
$ flutter run -d macos
$ flutter run -d chrome
```
Here's a composite of the app running on iOS, Android, desktop (macOS) and web:

<img src='readme/all-together-now.png' />

## Caveat
This sample code is likely to get stale fast! For the latest instructions, see [the flutter_desktop_embedding repo](https://github.com/google/flutter-desktop-embedding) and [the flutter_web repo](https://github.com/flutter/flutter_web).

## The trick
As of this writing, the trick to get a simple, plugin-less Flutter app to run across mobile, macOS and web from a single source code base is a bit of hackery in the main() function of your app:

```dart
import 'dart:io';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;

void main() {
  if (!identical(0, 0.0) && Platform.isMacOS)
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  runApp(MyApp());
}

// the rest of your app goes here...
```

As described in the [FDE Flutter Application Requirements](https://github.com/flutter/flutter/wiki/Desktop-shells#flutter-application-requirements), on the current desktop bits, debugDefaultTargetPlatformOverride must be set to TargetPlatform.iOS if you're running on macOS and TargetPlatform.Android otherwise. If you don't have code that does this before your Flutter code runs, you'll get a run-time exception and a blank screen when you run the app on the desktop.

However, the web runtime doesn't like the use of dart:io at all, including the Platform.isMacOS property and using it will cause an exception at run-time.

So, we use a little hackery relying on the fact that Flutter for web generates JavaScript to make Dart run in the browser and that numbers are implemented differently in JavaScript then in Dart. In the fullness of time, none of this is necessary, but it's a pretty cool hack for now.

Enjoy!