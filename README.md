# Flutter Multi-Platform Tic-Tac-Toe

A multi-platform Flutter sample game of tic-tac-toe.

## The Talk
I gave a talk at [the Portland-Area .NET User Group](http://padnug.org) recently, built this app in a live coding demo to show off Flutter and then did a bit of hackery to make it work across mobile, desktop and web. If you're interested in how the code was created, [check out the talk on YouTube](https://youtube.com/watch?v=bbaezQE1M2U).

## The Demo
You can [run Flutter Tic-Tac-Toe](http://csells.github.io/flutter_mplat_ttt/gh_pages/index.html) in your browswer right now!

## The Code
[Get Flutter working on your machine first](https://flutter.dev/docs/get-started/install), download [the code](https://github.com/csells/flutter_mplat_ttt) and then run the following commands:

```shell
$ flutter channel master # you need the latest and greatest bits for this to work
$ flutter upgrade        # you're living on the cutting edge now!
$ flutter run -d iphone  # or whatever matches your iOS simulator
$ flutter run -d android # or whatever matches your Android emulator
$ flutter run -d macos   # or -d windows
$ flutter run -d chrome  # to run the web version
```
Here's a composite of the app running on iOS, Android, desktop (macOS) and web:

<img src='readme/all-together-now.png' />

## Caveat
The multi-platform hackery part of this sample code is likely to get stale fast! For the latest instructions, see [the flutter_desktop_embedding repo](https://github.com/google/flutter-desktop-embedding). As things change, I'll try to keep this repo up to date with the details.

## The Trick
As of this writing, the trick to get a simple, plugin-less Flutter app to run across mobile, macOS, Windows and web from a single source code base is a bit of hackery in the file that contains the ```main()``` function of your app:

```dart
// main.dart
import 'dart:io';
import 'package:flutter/foundation.dart';

void setOverrideForDesktop() {
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
  setOverrideForDesktop();
  runApp(MyApp());
}

// the rest of your app goes here...
```

As described in the [FDE Flutter Application Requirements](https://github.com/flutter/flutter/wiki/Desktop-shells#flutter-application-requirements), on the current desktop bits, ```debugDefaultTargetPlatformOverride```
must be set to ```TargetPlatform.iOS``` if you're running on macOS and ```TargetPlatform.android``` for Windows or Linux. If you don't have code that does this before your Flutter code runs, you'll get a run-time exception and a blank screen when you run the app on the desktop.

On the other hand, the web runtime doesn't support the use of ```dart:io``` at all, even the ```Platform``` properties, and using it will cause an exception at run-time. For that reason, we check ``kIsWeb`` to see if we're running in a browser and duck out early if we are.

In the fullness of time, none of this is necessary, but it's a pretty cool hack for now.

Enjoy!