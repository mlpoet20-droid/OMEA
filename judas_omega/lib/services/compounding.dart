import '../models/symbol_data.dart';

class CompoundingAnalytics {
  double predictCapital(SymbolData symbol, double initialCapital, int minutes) {
    double growth = initialCapital;
    for(int i=0;i<minutes;i++){
      growth += growth * (symbol.ee * 1.0); // simple compounding placeholder
    }
    return growth;
  }
}
