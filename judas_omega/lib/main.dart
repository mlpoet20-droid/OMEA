import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/symbol_data.dart';
import 'widgets/realtime_chart.dart';
import 'widgets/engine_panel.dart';
import 'widgets/predictive_curve.dart';
import 'widgets/portfolio_heatmap.dart';
import 'widgets/session_overlay.dart';
import 'widgets/orderflow_overlay.dart';

void main() {
  runApp(const JudasOmegaApp());
}

/// ROOT APP
class JudasOmegaApp extends StatelessWidget {
  const JudasOmegaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JudasOmegaState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Judas Ω',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0B0E11),
          primaryColor: Colors.deepPurpleAccent,
        ),
        home: const JudasOmegaDashboard(),
      ),
    );
  }
}

/// GLOBAL STATE (SYSTEM CORE INTERFACE)
class JudasOmegaState extends ChangeNotifier {
  final List<String> symbols = [
    'EURUSD',
    'GBPUSD',
    'USDJPY',
    'USDCHF',
    'XAUUSD'
  ];

  String activeSymbol = 'EURUSD';
  String activeTF = '1m';

  double systemPotency = 0.0; // Σ
  double edgeEfficiency = 0.0; // EE
  double deviation = 0.0; // V
  double edgeless = 0.0; // EDGELESS exponent

  final Map<String, SymbolData> symbolMemory = {};

  Timer? _tick;

  JudasOmegaState() {
    for (final s in symbols) {
      symbolMemory[s] = SymbolData(symbol: s);
    }
    _startSystemPulse();
  }

  void _startSystemPulse() {
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      _evolveSystem();
    });
  }

  void _evolveSystem() {
    final data = symbolMemory[activeSymbol]!;

    data.simulateTick();

    deviation = data.deviation;
    edgeEfficiency = data.edgeEfficiency;
    systemPotency = data.systemPotency;
    edgeless = data.edgelessExponent;

    notifyListeners();
  }

  void setSymbol(String s) {
    activeSymbol = s;
    notifyListeners();
  }

  void setTF(String tf) {
    activeTF = tf;
    notifyListeners();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }
}

/// DASHBOARD
class JudasOmegaDashboard extends StatelessWidget {
  const JudasOmegaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JudasOmegaState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Judas Ω — Maximum Mode'),
        actions: [
          _symbolSelector(context),
          const SizedBox(width: 12),
          _timeframeSelector(context),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SessionOverlay(),
          Expanded(
            flex: 4,
            child: Stack(
              children: const [
                RealtimeChart(),
                OrderflowOverlay(),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: const [
                Expanded(child: EnginePanel()),
                Expanded(child: PredictiveCurve()),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: PortfolioHeatmap(),
          ),
        ],
      ),
    );
  }

  Widget _symbolSelector(BuildContext context) {
    final state = context.watch<JudasOmegaState>();

    return DropdownButton<String>(
      value: state.activeSymbol,
      dropdownColor: Colors.black,
      items: state.symbols
          .map((s) => DropdownMenuItem(
                value: s,
                child: Text(s),
              ))
          .toList(),
      onChanged: (v) => state.setSymbol(v!),
    );
  }

  Widget _timeframeSelector(BuildContext context) {
    final state = context.watch<JudasOmegaState>();
    const tfs = ['1m', '5m', '15m', '1h', '4h'];

    return DropdownButton<String>(
      value: state.activeTF,
      dropdownColor: Colors.black,
      items: tfs
          .map((tf) => DropdownMenuItem(
                value: tf,
                child: Text(tf),
              ))
          .toList(),
      onChanged: (v) => state.setTF(v!),
    );
  }
}
import 'package:flutter/material.dart';
import 'footprint.dart';
import 'trading_engine.dart';

void main() {
  runApp(JudasOmegaApp());
}

class JudasOmegaApp extends StatelessWidget {
  final FootPrintTracker tracker = FootPrintTracker();
  final TradeEngine engine;

  JudasOmegaApp({Key? key})
      : engine = TradeEngine(footprintTracker: FootPrintTracker()),
        super(key: key) {
    engine.startLiveTrading();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Judas Ω Dashboard')),
        body: ListView(
          children: engine.symbols.map((symbol) {
            return Column(
              children: [
                Text(symbol, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                FootPrintChart(entries: tracker.getEntriesBySymbol(symbol)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
