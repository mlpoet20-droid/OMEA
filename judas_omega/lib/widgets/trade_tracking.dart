import 'package:flutter/material.dart';
import 'TradesDB.dart';

class TradesListWidget extends StatelessWidget {
  final TradesDB tradesDB;
  final String symbol;

  const TradesListWidget({Key? key, required this.tradesDB, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TradeEntry> trades = tradesDB.getTradesBySymbol(symbol);

    if (trades.isEmpty) return Center(child: Text("No trades for $symbol"));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: trades.length,
      itemBuilder: (context, index) {
        TradeEntry t = trades[index];
        return ListTile(
          title: Text("${t.symbol} | ${t.tradeType}"),
          subtitle: Text("Price: ${t.price}, Size: ${t.positionSize}, EE: ${t.ee.toStringAsFixed(2)}, Σ: ${t.potency.toStringAsFixed(2)}, Dev: ${t.deviation.toStringAsFixed(5)}"),
          trailing: Text("PnL: ${t.pnl.toStringAsFixed(2)}"),
        );
      },
    );
  }
}
