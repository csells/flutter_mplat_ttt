# Flutter Multi-Platform Tic-Tac-Toe

A multi-platform Flutter sample game of tic-tac-toe.

## The Talk
I gave a talk at [the Portland-Area .NET User Group](http://padnug.org) recently, built this app in a live coding demo to show off Flutter and then did a bit of hackery to make it work across mobile, desktop and web. If you're interested in how the code was created, [check out the talk on YouTube](https://youtube.com/watch?v=bbaezQE1M2U).

## The Demo
You can [run Flutter Tic-Tac-Toe](http://csells.github.io/flutter_mplat_ttt/gh_pages/index.html) in your browswer right now!

## The Code
[Get Flutter working on your machine first](https://flutter.dev/docs/get-started/install), download [the code](https://github.com/csells/flutter_mplat_ttt) and then run the following commands:

```shell
$ flutter run -d iphone  # or whatever matches your iOS simulator
$ flutter run -d android # or whatever matches your Android emulator
$ flutter run -d macos   # or -d windows
$ flutter run -d chrome
```
Here's a composite of the app running on iOS, Android, desktop (macOS) and web:

<img src='readme/all-together-now.png' />

## Caveat
The multi-platform hackery part of this sample code is likely to get stale fast! For the latest instructions, see [the flutter_desktop_embedding repo](https://github.com/google/flutter-desktop-embedding) and [the flutter_web repo](https://github.com/flutter/flutter_web).

## The Trick
As of this writing, the trick to get a simple, plugin-less Flutter app to run across mobile, macOS, Windows and web from a single source code base is a bit of hackery in the main() function of your app:

```dart
import 'dart:io';
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride, kIsWeb;

void _desktopInitHack() {
  if (kIsWeb) return;

  if (Platform.isMacOS) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  } else if (Platform.isFuchsia) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _desktopInitHack();
  runApp(MyApp());
}

// the rest of your app goes here...
```

As described in the [FDE Flutter Application Requirements](https://github.com/flutter/flutter/wiki/Desktop-shells#flutter-application-requirements), on the current desktop bits, debugDefaultTargetPlatformOverride must be set to TargetPlatform.iOS if you're running on macOS and TargetPlatform.android otherwise. If you don't have code that does this before your Flutter code runs, you'll get a run-time exception and a blank screen when you run the app on the desktop.

However, the web runtime doesn't like the use of dart:io at all, even the Platform.isMacOS property, and using it will cause an exception at run-time.

So, to keep the code from causing a run-time exception anywhere, we use a little-known constant named kIsWeb to bail early. In the fullness of time, none of this is necessary, but it's a pretty cool hack for now.

Enjoy!