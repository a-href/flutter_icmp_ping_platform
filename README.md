# flutter_icmp_ping_platform


Flutter plugin that sends ICMP ECHO_REQUEST.

Fork from [![pub package](https://img.shields.io/pub/v/flutter_icmp_ping.svg)](https://pub.dartlang.org/packages/flutter_icmp_ping)

## Supported platforms

- Flutter Android
- Flutter iOS

## Getting Started

To use this plugin, add `flutter_icmp_ping_platform` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```yaml
dependencies:
  flutter_icmp_ping_platform:
```

Import the library in your file.

```dart
import 'package:flutter_icmp_ping_platform/flutter_icmp_ping_platform.dart';
```

See the `example` directory for a complete sample app using Ping.
Or use the Ping like below.

```dart
try {
  final ping = Ping(
    'google.com',
    count: 3,
    timeout: 1,
    interval: 1,
    ipv6: false,
    ttl: 40,
  );
  ping.stream.listen((event) {
    print(event);
  });
} catch (e) {
  print('error $e');
}
```
