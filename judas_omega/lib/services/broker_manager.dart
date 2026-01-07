import 'broker_api.dart';
import '../models/symbol_data.dart';

class BrokerManager {
  final BrokerAPI api = BrokerAPI();
  
  Future<void> executeTrade(SymbolData symbol, double volume, String direction) async {
    await api.placeOrder(symbol, volume, direction);
    // Add logging, EE, Σ thresholds checks here
  }
}
