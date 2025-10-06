# Global State Manager

`mg_sub` is a **lightweight state management helper** for Flutter, inspired by BLoC and Riverpod, built on:

* `rxdart` (Streams)
* `get_it` (Dependency Injection)

It allows you to:

* Create reactive state controllers.
* Observe lifecycle events (`onCreate`, `onChange`, `onClose`).
* Access and reuse controllers globally by `instanceName`.

---

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  mg_sub: latest
  mg_sub_lint: latest
```

---

## 🧠 Basic Example

### `lib/main.dart`

```dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_sub/mg_sub.dart';

/// ------------------------------------------------
/// Example Controller
/// ------------------------------------------------
class DataController extends Sub<String> {
  DataController(super.instanceName);

  void loadData() async {
    emit("Loading...");
    await Future.delayed(const Duration(seconds: 2));
    emit("Hello from controller #$instanceName");
  }

  void throwError() {
    emit("Something went wrong!");
  }
}

/// ------------------------------------------------
/// Example App
/// ------------------------------------------------
void main() {
  GetIt.I.registerFactoryParam<DataController, String, void>(
    (name, _) => DataController(name),
  );
  Sub.observer = const MySubObserver();
  runApp(const MyApp());
}

/// ------------------------------------------------
/// App with two pages
/// ------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sub Example',
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: Center(
        child: SubBuilder<DataController, String>(
          instanceName: "1",
          close: false, // keep controller alive when leaving page
          builder: (context, state) {
            if (state == "Loading...") {
              return const CircularProgressIndicator();
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Sub.of<DataController>('1').loadData();
                    },
                    child: const Text("Load Data"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SecondPage(),
                        ),
                      );
                    },
                    child: const Text("Go to Page 2"),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Center(
        child: SubBuilder<DataController, String>(
          instanceName: "1",
          close: false,
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("From Page 2: $state"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: Sub.of<DataController>('1').loadData,
                  child: const Text("Reload"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ------------------------------------------------
/// Custom observer for logging
/// ------------------------------------------------
class MySubObserver extends SubObserver {
  const MySubObserver();

  @override
  void onCreate(Sub<dynamic> sub) {
    log(name: "SubObserver", "CREATED ${sub.runtimeType} ${sub.instanceName} 📦 🆕");
    super.onCreate(sub);
  }

  @override
  void onClose(Sub<dynamic> sub) {
    log(name: "SubObserver", "CLOSED ${sub.runtimeType} ${sub.instanceName} 📦 💀");
    super.onClose(sub);
  }

  @override
  void onChange(Sub<dynamic> sub, dynamic prev, dynamic next) {
    log(name: "SubObserver", "CHANGE ${sub.runtimeType} ${sub.instanceName} 📝 $prev ➡️ $next");
    super.onChange(sub, prev, next);
  }
}
```
