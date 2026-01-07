import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/symbol_data.dart';

class PredictiveCurve extends StatelessWidget {
  final SymbolData symbolData;

  PredictiveCurve({required this.symbolData});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> predicted = [];
    for (int i = 0; i < symbolData.prices.length; i++) {
      predicted.add(FlSpot(i.toDouble(), symbolData.prices[i] + symbolData.ee * 50));
    }

    return Container(
      height: 120,
      padding: EdgeInsets.all(8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: predicted,
              isCurved: true,
              color: Colors.orangeAccent,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.orangeAccent.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }
}
