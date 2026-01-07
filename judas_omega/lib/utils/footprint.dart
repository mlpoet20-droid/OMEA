// FootPrint.dart - Fully integrated for Judas Ω
import 'dart:collection';
import 'package:flutter/material.dart';

// Footprint entry for each trade or deviation event
class FootPrintEntry {
  final String symbol;
  final DateTime timestamp;
  final double deviation; // deviation from expected system state
  final double systemPotency; // Σ
  final double edgeEfficiency; // EE
  final double tradeSize; // position size
  final String tradeType; // scalping / intraday / swing

  FootPrintEntry({
    required this.symbol,
    required this.timestamp,
    required this.deviation,
    required this.systemPotency,
    required this.edgeEfficiency,
    required this.tradeSize,
    required this.tradeType,
  });
}

// Footprint tracker for all symbols
class FootPrintTracker {
  final int maxEntries;
  final Queue<FootPrintEntry> _entries = Queue();

  FootPrintTracker({this.maxEntries = 5000});

  void addEntry(FootPrintEntry entry) {
    if (_entries.length >= maxEntries) {
      _entries.removeFirst();
    }
    _entries.addLast(entry);
  }

  List<FootPrintEntry> get entries => _entries.toList();

  List<FootPrintEntry> getEntriesBySymbol(String symbol) =>
      _entries.where((e) => e.symbol == symbol).toList();

  double averageEE(String symbol) {
    var list = getEntriesBySymbol(symbol);
    if (list.isEmpty) return 0;
    return list.map((e) => e.edgeEfficiency).reduce((a, b) => a + b) / list.length;
  }

  double maxDeviation(String symbol) {
    var list = getEntriesBySymbol(symbol);
    if (list.isEmpty) return 0;
    return list.map((e) => e.deviation).reduce((a, b) => a > b ? a : b);
  }

  double currentΣ(String symbol) {
    var list = getEntriesBySymbol(symbol);
    if (list.isEmpty) return 0;
    return list.map((e) => e.systemPotency).reduce((a, b) => a + b) / list.length;
  }
}

// Visualization widget for mobile app dashboard
class FootPrintChart extends StatelessWidget {
  final List<FootPrintEntry> entries;
  final Color lineColor;

  const FootPrintChart({
    Key? key,
    required this.entries,
    this.lineColor = Colors.amber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return Center(child: Text("No Footprints"));

    return Container(
      height: 200,
      padding: EdgeInsets.all(8),
      child: CustomPaint(
        painter: _FootPrintPainter(entries, lineColor),
      ),
    );
  }
}

class _FootPrintPainter extends CustomPainter {
  final List<FootPrintEntry> entries;
  final Color lineColor;

  _FootPrintPainter(this.entries, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double maxDeviation = entries.isNotEmpty
        ? entries.map((e) => e.deviation).reduce((a, b) => a > b ? a : b)
        : 1;

    for (int i = 0; i < entries.length - 1; i++) {
      double x1 = i * size.width / entries.length;
      double y1 = size.height - (entries[i].deviation / maxDeviation) * size.height;
      double x2 = (i + 1) * size.width / entries.length;
      double y2 = size.height - (entries[i + 1].deviation / maxDeviation) * size.height;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
