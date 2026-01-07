import 'dart:collection';

class TradeEntry {
  final String symbol;
  final DateTime timestamp;
  final double price;
  final double positionSize;
  final String tradeType;
  final double pnl; // profit/loss
  final double ee; // Edge Efficiency at execution
  final double potency; // Σ
  final double deviation;

  TradeEntry({
    required this.symbol,
    required this.timestamp,
    required this.price,
    required this.positionSize,
    required this.tradeType,
    required this.pnl,
    required this.ee,
    required this.potency,
    required this.deviation,
  });
}

class TradesDB {
  final int maxEntries;
  final Queue<TradeEntry> _trades = Queue();

  TradesDB({this.maxEntries = 10000});

  void addTrade(TradeEntry trade) {
    if (_trades.length >= maxEntries) _trades.removeFirst();
    _trades.addLast(trade);
  }

  List<TradeEntry> get allTrades => _trades.toList();

  List<TradeEntry> getTradesBySymbol(String symbol) =>
      _trades.where((t) => t.symbol == symbol).toList();

  double cumulativePnL(String symbol) =>
      getTradesBySymbol(symbol).fold(0.0, (sum, t) => sum + t.pnl);

  double averageEE(String symbol) {
    var trades = getTradesBySymbol(symbol);
    if (trades.isEmpty) return 0.0;
    return trades.map((t) => t.ee).reduce((a, b) => a + b) / trades.length;
  }
}
