import 'dart:async';
import '../models/symbol_data.dart';

class DataFeed {
  final Map<String, SymbolData> _symbols = {};
  final StreamController<List<SymbolData>> _controller = StreamController.broadcast();

  void subscribeToSymbols(List<String> symbolNames, Function(List<SymbolData>) onUpdate) {
    for (var name in symbolNames) {
      _symbols[name] = SymbolData(name: name);
    }
    _controller.stream.listen(onUpdate);
    _simulateMarket();
  }

  void _simulateMarket() {
    Timer.periodic(Duration(seconds: 1), (_) {
      _symbols.forEach((key, sym) {
        double lastPrice = sym.prices.isEmpty ? 100.0 : sym.prices.last;
        double newPrice = lastPrice + ([-1,1][DateTime.now().second % 2] * (0.1 + (DateTime.now().millisecond % 10)/100));
        sym.prices.add(newPrice);

        // Update Judas Ω metrics
        sym.v = newPrice - lastPrice;
        sym.sigma = sym.v.abs() * 1.5; // placeholder for system potency
        sym.ee = sym.v / (lastPrice == 0 ? 1 : lastPrice);
        sym.ire = sym.ee * 2; 
        sym.edgeless = sym.ee * 1.2;
        sym.mee = sym.ee * 0.8;
        sym.rae = sym.v * 0.5;
        sym.balanceState = sym.v * 0.3;
        sym.deviationFlux = sym.v * 0.7;
        sym.exploitableEE = sym.ee * 1.1;
      });
      _controller.add(_symbols.values.toList());
    });
  }
}
