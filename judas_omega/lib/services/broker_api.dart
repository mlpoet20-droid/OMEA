import '../models/symbol_data.dart';

class BrokerAPI {
  Future<bool> placeOrder(SymbolData symbol, double volume, String direction) async {
    print("Executing ${direction.toUpperCase()} order for ${symbol.name}, volume $volume");
    await Future.delayed(Duration(milliseconds: 500));
    return true; // placeholder success
  }

  Future<double> getAccountBalance() async {
    return 1000.0; // placeholder
  }
}
