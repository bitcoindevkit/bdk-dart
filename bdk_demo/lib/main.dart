import 'package:bdk_dart/bdk.dart' as bdk;
import 'package:flutter/material.dart';

const _demoDescriptor =
    'wpkh(tprv8ZgxMBicQKsPf2qfrEygW6fdYseJDDrVnDv26PH5BHdvSuG6ecCbHqLVof9yZcMoM31z9ur3tTYbSnr1WBqbGX97CbXcmp5H6qeMpyvx35B/'
    '84h/1h/0h/0/*)';
const _descriptorPreviewLength = 56;

enum DemoLoadState { idle, loading, success, error }

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
      home: const MyHomePage(title: 'BDK Dart Reference Demo'),
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
  DemoLoadState _state = DemoLoadState.idle;
  String? _networkName;
  String? _descriptorSnippet;
  String? _statusMessage;
  String? _error;

  Future<void> _loadDemoData() async {
    setState(() {
      _state = DemoLoadState.loading;
      _networkName = null;
      _descriptorSnippet = null;
      _error = null;
      _statusMessage =
          'Loading the bindings and building an example testnet descriptor...';
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 350));

      final network = bdk.Network.testnet;
      final descriptor = bdk.Descriptor(
        descriptor: _demoDescriptor,
        network: network,
      );

      setState(() {
        _state = DemoLoadState.success;
        _networkName = network.name;
        _descriptorSnippet = _shortenDescriptor(descriptor.toString());
        _error = null;
        _statusMessage =
            'Ready. The demo loaded the bindings and returned example wallet data.';
      });
    } catch (error) {
      setState(() {
        _state = DemoLoadState.error;
        _networkName = null;
        _descriptorSnippet = null;
        _error = error.toString();
        _statusMessage =
            'The demo could not load the example wallet information.';
      });
    }
  }

  String _shortenDescriptor(String descriptor) {
    if (descriptor.length <= _descriptorPreviewLength) {
      return descriptor;
    }

    return '${descriptor.substring(0, _descriptorPreviewLength)}...';
  }

  String get _stateLabel => switch (_state) {
    DemoLoadState.idle => 'Idle',
    DemoLoadState.loading => 'Loading',
    DemoLoadState.success => 'Success',
    DemoLoadState.error => 'Error',
  };

  String get _stateTitle => switch (_state) {
    DemoLoadState.idle => 'Ready to run the demo',
    DemoLoadState.loading => 'Loading example wallet data',
    DemoLoadState.success => 'Demo data loaded',
    DemoLoadState.error => 'Unable to load demo data',
  };

  String get _stateDescription => switch (_state) {
    DemoLoadState.idle =>
      'Run the example to verify that Flutter can call into bdk_dart and '
          'surface basic wallet information.',
    DemoLoadState.loading =>
      'The demo is constructing the example descriptor and reading its '
          'network metadata.',
    DemoLoadState.success =>
      'The bindings responded successfully and the returned demo information '
          'is shown below.',
    DemoLoadState.error =>
      'An error occurred while the demo was loading the example wallet data.',
  };

  String get _actionLabel => switch (_state) {
    DemoLoadState.idle => 'Load example testnet data',
    DemoLoadState.loading => 'Loading demo data...',
    DemoLoadState.success => 'Reload demo data',
    DemoLoadState.error => 'Try loading the demo again',
  };

  IconData get _actionIcon => switch (_state) {
    DemoLoadState.idle => Icons.play_circle_fill,
    DemoLoadState.loading => Icons.hourglass_top,
    DemoLoadState.success => Icons.refresh,
    DemoLoadState.error => Icons.refresh,
  };

  IconData get _stateIcon => switch (_state) {
    DemoLoadState.idle => Icons.info_outline,
    DemoLoadState.loading => Icons.sync,
    DemoLoadState.success => Icons.check_circle,
    DemoLoadState.error => Icons.error_outline,
  };

  Color _stateColor(ColorScheme colorScheme) => switch (_state) {
    DemoLoadState.idle => colorScheme.secondary,
    DemoLoadState.loading => colorScheme.primary,
    DemoLoadState.success => Colors.green.shade700,
    DemoLoadState.error => colorScheme.error,
  };

  bool get _hasResult =>
      _networkName != null || _descriptorSnippet != null || _error != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = _stateColor(colorScheme);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'See how a Flutter app can call bdk_dart',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Text(
                'This example loads the Dart bindings, constructs an example '
                'testnet descriptor in memory, and shows the returned wallet '
                'data. It is meant to be a simple reference screen, not a full '
                'wallet app.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'What this demo covers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      _InfoBullet(
                        icon: Icons.extension,
                        text: 'Loads the bdk_dart bindings from Flutter code.',
                      ),
                      SizedBox(height: 12),
                      _InfoBullet(
                        icon: Icons.account_tree_outlined,
                        text:
                            'Builds an example descriptor on the testnet network.',
                      ),
                      SizedBox(height: 12),
                      _InfoBullet(
                        icon: Icons.visibility_outlined,
                        text:
                            'Shows clear idle, loading, success, and error states.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(_stateIcon, color: accentColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _stateTitle,
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _stateDescription,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          Chip(
                            avatar: Icon(
                              _stateIcon,
                              size: 18,
                              color: accentColor,
                            ),
                            label: Text(_stateLabel),
                          ),
                          if (_statusMessage != null)
                            Text(
                              _statusMessage!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_hasResult) ...<Widget>[
                const SizedBox(height: 16),
                Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _error == null
                              ? 'Returned demo data'
                              : 'Error details',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        if (_networkName != null)
                          _DetailBlock(label: 'Network', value: _networkName!),
                        if (_descriptorSnippet != null) ...<Widget>[
                          const SizedBox(height: 12),
                          _DetailBlock(
                            label: 'Descriptor preview',
                            value: _descriptorSnippet!,
                            monospace: true,
                          ),
                        ],
                        if (_statusMessage != null) ...<Widget>[
                          const SizedBox(height: 12),
                          _DetailBlock(
                            label: 'Status message',
                            value: _statusMessage!,
                          ),
                        ],
                        if (_error != null) ...<Widget>[
                          const SizedBox(height: 12),
                          _DetailBlock(
                            label: 'Error',
                            value: _error!,
                            error: true,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _state == DemoLoadState.loading
                      ? null
                      : _loadDemoData,
                  icon: _state == DemoLoadState.loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(_actionIcon),
                  label: Text(_actionLabel),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The descriptor shown here is hard-coded for demo purposes so '
                'the screen stays focused on how to wire Flutter into bdk_dart.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBullet extends StatelessWidget {
  const _InfoBullet({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.label,
    required this.value,
    this.monospace = false,
    this.error = false,
  });

  final String label;
  final String value;
  final bool monospace;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: error
                ? colorScheme.errorContainer
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style:
                (monospace
                        ? theme.textTheme.bodyMedium?.copyWith(
                            fontFamily: 'monospace',
                          )
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(
                      color: error
                          ? colorScheme.onErrorContainer
                          : colorScheme.onSurface,
                      height: 1.4,
                    ),
          ),
        ),
      ],
    );
  }
}
