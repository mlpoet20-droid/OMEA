import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/symbol_data.dart';

class RealtimeChart extends StatelessWidget {
  final SymbolData symbolData;

  RealtimeChart({required this.symbolData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    for (int i = 0; i < symbolData.prices.length; i++) {
      spots.add(FlSpot(i.toDouble(), symbolData.prices[i]));
    }

    return Container(
      height: 180,
      padding: EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.cyanAccent,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.cyanAccent.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }
}
