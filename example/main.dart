// lib/main.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mg_sub/mg_sub.dart';

/// Example Sub controller: Counter
class CounterSub extends Sub<int> {
  CounterSub(String name) : super(0, name);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

/// Example Sub controller: Toggle
class ToggleSub extends Sub<bool> {
  ToggleSub(String name) : super(false, name);

  void toggle() => emit(!state);
}

void main() {
  Sub.observer = MySubObserver();
  // Register Sub controllers with GetIt
  GetIt.I.registerFactoryParam<CounterSub, String, void>(
    (name, _) => CounterSub(name),
  );
  GetIt.I.registerFactoryParam<ToggleSub, String, void>(
    (name, _) => ToggleSub(name),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'MG Sub Example', home: const CounterPage());
  }
}

/// Screen 1: Counter
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 1: Counter')),
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
            heroTag: 'next',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TogglePage()),
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

/// Screen 2: Toggle
class TogglePage extends StatelessWidget {
  const TogglePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 2: Toggle')),
      body: Center(
        child: SubBuilder<ToggleSub, bool>(
          id: 'toggle1',
          builder: (context, state) {
            return Text(
              'Toggle is ${state ? "ON" : "OFF"}',
              style: const TextStyle(fontSize: 32),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'toggle',
            onPressed: () => Sub.of<ToggleSub>('toggle1').toggle(),
            child: const Icon(Icons.toggle_on),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'next2',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CombinedPage()),
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

/// Screen 3: Combined (observe Counter + Toggle)
class CombinedPage extends StatelessWidget {
  const CombinedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 3: Combined')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SubBuilder<CounterSub, int>(
            id: 'counter1',
            builder: (context, state) =>
                Text('Counter: $state', style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 20),
          SubBuilder<ToggleSub, bool>(
            id: 'toggle1',
            builder: (context, state) => Text(
              'Toggle is ${state ? "ON" : "OFF"}',
              style: const TextStyle(fontSize: 28),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ClearPage()),
            ),
            child: const Text('Go to Clear Screen'),
          ),
        ],
      ),
    );
  }
}

/// Screen 4: Clear all controllers
class ClearPage extends StatelessWidget {
  const ClearPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 4: Clear All')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Sub.clear();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('All Sub controllers cleared!')),
            );
          },
          child: const Text('Clear All Controllers'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'next4',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReopenPage()),
        ),
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

/// Screen 5: Reopen controllers after clear
class ReopenPage extends StatelessWidget {
  const ReopenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Screen 5: Reopen Controllers')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SubBuilder<CounterSub, int>(
            id: 'counter1',
            builder: (context, state) =>
                Text('Counter: $state', style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 20),
          SubBuilder<ToggleSub, bool>(
            id: 'toggle1',
            builder: (context, state) => Text(
              'Toggle is ${state ? "ON" : "OFF"}',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ],
      ),
    );
  }
}

class MySubObserver extends SubObserver {
  @override
  void onCreate(Sub<dynamic> sub) {
    log(name: "SubObserver", "CREATED ${sub.runtimeType} #${sub.id} 📦 🆕");
    super.onCreate(sub);
  }

  @override
  void onClose(Sub<dynamic> sub) {
    log(name: "SubObserver", "CLOSED ${sub.runtimeType} #${sub.id} 📦 💀");
    super.onClose(sub);
  }

  @override
  void onChange(Sub<dynamic> sub, dynamic prev, dynamic next) {
    log(
      name: "SubObserver",
      "CHANGE ${sub.runtimeType} #${sub.id} 📝 $prev ➡️ $next",
    );
    super.onChange(sub, prev, next);
  }
}
