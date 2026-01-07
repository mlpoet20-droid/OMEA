import 'package:flutter/material.dart';
import '../models/symbol_data.dart';

class EnginePanel extends StatelessWidget {
  final SymbolData symbol;

  const EnginePanel({
    Key? key,
    required this.symbol,
  }) : super(key: key);

  Color _stateColor(double value) {
    if (value > 1.2) return Colors.greenAccent;
    if (value > 0.6) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  Widget _metric(String label, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(4),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _stateColor(value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: const Color(0xFF0E0E0E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  symbol.symbol,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: symbol.isActive
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    symbol.isActive ? 'ACTIVE' : 'DORMANT',
                    style: TextStyle(
                      color:
                          symbol.isActive ? Colors.green : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Metrics
            _metric('Deviation (V)', symbol.deviation),
            const SizedBox(height: 12),
            _metric('Edge Efficiency (EE)', symbol.edgeEfficiency),
            const SizedBox(height: 12),
            _metric('Potency (Σ)', symbol.potency),
            const SizedBox(height: 12),
            _metric('EDGELESS', symbol.edgeless),

            const SizedBox(height: 16),

            // Leverage readiness (future use)
            Text(
              'Leverage Factor: ${symbol.leverageFactor.toStringAsFixed(2)}×',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
