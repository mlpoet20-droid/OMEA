import '../models/symbol_data.dart';

class AlertManager {
  void checkAlerts(SymbolData symbol) {
    if (symbol.ee > 0.02) {
      print("ALERT: ${symbol.name} EE threshold exceeded: ${symbol.ee}");
    }
    if (symbol.exploitableEE > 0.03) {
      print("ALERT: ${symbol.name} exploitable EE high: ${symbol.exploitableEE}");
    }
  }
}
