# 🧩 mg_sub — Mini Global SubState Manager

`mg_sub` is a **lightweight state management helper** for Flutter inspired by BLoC and Riverpod, built on:
- `rxdart` (Streams)
- `freezed` (immutable states)
- `get_it` (Dependency Injection)

It allows you to:
- Create reactive state controllers.
- Observe lifecycle events (`onCreate`, `onChange`, `onClose`).
- Access and reuse controllers globally by `instanceName`.

---

## 🚀 Installation

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  mg_sub: latest
```

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
  DataController(super.name);

  void loadData() async {
    emitLoading();
    await Future.delayed(const Duration(seconds: 2));
    emitSuccess("Hello from controller #$instanceName");
  }

  void throwError() {
    emitFailure("Something went wrong!");
  }
}

/// ------------------------------------------------
/// Example App
/// ------------------------------------------------
void main() {
  GetIt.I.registerFactoryParam<DataController, String, void>((name, _) => DataController(name));
  Sub.observer = const MySubObserver();
  runApp(const MyApp());
}

/// ------------------------------------------------
/// App with two pages and pushAndRemoveUntil
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
    /// ⚠️ Don't access `Sub.of<DataController>('1')` inside build()
    /// because if the controller was disposed (e.g., autoDispose = true),
    /// `Sub.of()` will create a NEW instance — not the last one.
    /// Use `Sub.of<DataController>('1')` inside callbacks. for get latest instance

    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: Center(
        child: SubBuilder<DataController, String>(
          instanceName: "1",
          autoDispose: true,
          builder: (context, state) {
            return state.when(
              initial: () => ElevatedButton(
                onPressed: () {
                  /// Access `Sub.of<DataController>('1')` inside callbacks
                  /// to get latest instance
                  Sub.of<DataController>('1').loadData();
                },
                child: const Text("Load Data"),
              ),
              loading: () => const CircularProgressIndicator(),
              success: (data) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SecondPage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text("Go to Page 2"),
                  ),
                ],
              ),
              failure: (error) => Text(error),
            );
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
    /// ⚠️ Don't access `Sub.of<DataController>('1')` inside build()
    /// because if the controller was disposed (e.g., autoDispose = true),
    /// `Sub.of()` will create a NEW instance — not the last one.
    /// Use `Sub.of<DataController>('1')` inside callbacks. for get latest instance

    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: Center(
        child: SubBuilder<DataController, String>(
          instanceName: "1",
          autoDispose: false,
          builder: (context, state) {
            return state.when(
              initial: () => const Text("Initial"),
              loading: () => const CircularProgressIndicator(),
              success: (data) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("From Page 2: $data"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    /// Access `Sub.of<DataController>('1')` inside callbacks
                    /// to get latest instance
                    onPressed: Sub.of<DataController>('1').loadData,
                    child: const Text("Reload"),
                  ),
                ],
              ),
              failure: (error) => Text(error),
            );
          },
        ),
      ),
    );
  }
}

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
  void onChange(Sub<dynamic> sub, SubState<dynamic> prev, SubState<dynamic> next) {
    log(name: "SubObserver", "CHANGE ${sub.runtimeType} ${sub.instanceName} 📝 $prev ➡️ $next");
    super.onChange(sub, prev, next);
  }
}

```
