# Global State Manager Depending on `get_it`

`mg_sub` is a **lightweight state management helper** for Flutter, inspired by BLoC and Riverpod

It allows you to:
* Create reactive state controllers.
* Observe lifecycle events (`onCreate`, `onChange`, `onClose`).
* Access and reuse controllers globally by `id` Without BuildContext.

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
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_sub/mg_sub.dart';

/// Example Sub controller: Counter
class CounterSub extends Sub<int> {
  CounterSub(String name) : super(0, name);

  void increment() => emit(currentState + 1);
  void decrement() => emit(currentState - 1);
}

void main() {
  // Register Sub controllers with GetIt
  GetIt.I.registerFactoryParam<CounterSub, String, void>(
    (name, _) => CounterSub(name),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Sub Example', home: const CounterPage());
  }
}

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sub Example')),
      body: Center(
        child: SubBuilder<CounterSub, int>(
          id: 'counter1',
          builder: (context, state) {
            return Text(
              'Counter: $state',
              style: const TextStyle(fontSize: 32),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: () => Sub.of<CounterSub>('counter1').increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'dec',
            onPressed: () => Sub.of<CounterSub>('counter1').decrement(),
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: () {
              Sub.clear(); // Clears all controllers
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All Sub controllers cleared!')),
              );
            },
            child: const Icon(Icons.clear_all),
          ),
        ],
      ),
    );
  }
}

```
