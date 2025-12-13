import 'package:bdk_dart/bdk.dart' as bdk;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BDK Dart Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BDK Dart Proof of Concept'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _networkName;
  String? _descriptorSnippet;
  String? _error;

  void _showSignetNetwork() {
    try {
      final network = bdk.Network.testnet;
      final descriptor = bdk.Descriptor(
        'wpkh(tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/'
        '84h/1h/0h/0/*)',
        network,
      );

      setState(() {
        _networkName = network.name;
        _descriptorSnippet = descriptor.toString().substring(0, 32);
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _networkName = null;
        _descriptorSnippet = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              _error != null
                  ? Icons.error_outline
                  : _networkName != null
                  ? Icons.check_circle
                  : Icons.network_check,
              size: 80,
              color: _error != null
                  ? Colors.red
                  : _networkName != null
                  ? Colors.green
                  : Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text('BDK bindings status', style: TextStyle(fontSize: 20)),
            if (_networkName != null) ...[
              Text(
                'Network: $_networkName',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_descriptorSnippet != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    'Descriptor sample: $_descriptorSnippet…',
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
            ] else if (_error != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ] else ...[
              const Text('Press the button to load bindings'),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSignetNetwork,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.play_circle_fill),
        label: const Text('Load Dart binding'),
      ),
    );
  }
}
