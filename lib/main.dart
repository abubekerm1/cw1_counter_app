import 'package:flutter/material.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatelessWidget {
  const CounterImageToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _isDark = false;
  bool _isFirstImage = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
      value: 1.0,
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _changeCounter(int amount) {
    setState(() {
      _counter += amount;

      if (_counter < 0) {
        _counter = 0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  Future<void> _toggleImage() async {
    await _controller.reverse();

    setState(() {
      _isFirstImage = !_isFirstImage;
    });

    await _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CW1 Counter & Toggle'),
          actions: [
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(
                _isDark ? Icons.light_mode : Icons.dark_mode,
              ),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Counter: $_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _counter > 0 ? () => _changeCounter(-1) : null,
                      child: const Text('-1'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _changeCounter(1),
                      child: const Text('+1'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _changeCounter(5),
                      child: const Text('+5'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _changeCounter(10),
                      child: const Text('+10'),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: _counter > 0 ? _resetCounter : null,
                  child: const Text('Reset'),
                ),

                const SizedBox(height: 24),

                FadeTransition(
                  opacity: _fade,
                  child: Image.asset(
                    _isFirstImage
                        ? 'assets/image1.png'
                        : 'assets/image2.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: _toggleImage,
                  child: const Text('Toggle Image'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}