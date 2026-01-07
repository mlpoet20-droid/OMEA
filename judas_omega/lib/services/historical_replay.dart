import '../models/symbol_data.dart';

class HistoricalReplay {
  void replay(List<SymbolData> symbols, int speedMultiplier) {
    print("Replaying historical data for ${symbols.length} symbols at x$speedMultiplier speed");
  }
}
