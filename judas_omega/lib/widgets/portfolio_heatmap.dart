import 'package:flutter/material.dart';
import '../models/symbol_data.dart';

class PortfolioHeatmap extends StatelessWidget {
  final SymbolData symbolData;

  PortfolioHeatmap({required this.symbolData});

  @override
  Widget build(BuildContext context) {
    double gainPercent = symbolData.exploitableEE * 100;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      height: 50,
      color: Colors.black,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * (gainPercent / 100),
            color: gainPercent >= 0 ? Colors.greenAccent : Colors.redAccent,
          ),
          Center(child: Text("${gainPercent.toStringAsFixed(2)}%", style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
