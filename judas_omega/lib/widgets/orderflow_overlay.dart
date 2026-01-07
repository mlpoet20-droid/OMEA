import 'package:flutter/material.dart';
import '../utils/footprint.dart';

class OrderflowOverlay extends StatelessWidget {
  final Footprint footprint = Footprint();

  final double bid;
  final double ask;

  OrderflowOverlay({required this.bid, required this.ask});

  @override
  Widget build(BuildContext context) {
    double deviation = footprint.calculateOrderflowDeviation(bid, ask);
    Color color = deviation > 0.05 ? Colors.redAccent : Colors.greenAccent;

    return Container(
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text("Orderflow Deviation: ${deviation.toStringAsFixed(4)}", style: TextStyle(color: Colors.white)),
    );
  }
}
