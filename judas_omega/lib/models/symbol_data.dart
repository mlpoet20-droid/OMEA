import 'dart:math';

class SymbolData {
  final String symbol;

  // Core price memory
  double lastPrice;
  double meanPrice;
  double volatility;

  // Judas Ω metrics
  double deviation;        // V
  double edgeEfficiency;   // EE
  double potency;          // Σ
  double edgeless;         // EDGELESS exponent

  // Internal memory
  int tickCount;
  double momentum;
  double decay;

  SymbolData({
    required this.symbol,
    required double initialPrice,
  })  : lastPrice = initialPrice,
        meanPrice = initialPrice,
        volatility = 0.0,
        deviation = 0.0,
        edgeEfficiency = 0.0,
        potency = 0.0,
        edgeless = 0.0,
        tickCount = 0,
        momentum = 0.0,
        decay = 1.0;

  /// 🔁 Call this on every tick (simulated or real)
  void update(double newPrice) {
    tickCount++;

    // --- Price delta ---
    double delta = newPrice - lastPrice;
    lastPrice = newPrice;

    // --- Adaptive mean (non-linear) ---
    meanPrice += (newPrice - meanPrice) * 0.05;

    // --- Volatility expansion ---
    volatility = (volatility * 0.9) + (delta.abs() * 0.1);

    // --- Deviation pressure ---
    deviation = (newPrice - meanPrice) / (volatility + 0.00001);

    // --- Momentum memory ---
    momentum = (momentum * 0.8) + (delta * 0.2);

    // --- Edge Efficiency ---
    edgeEfficiency = _computeEdgeEfficiency();

    // --- Potency accumulation ---
    potency += edgeEfficiency * deviation.abs();

    // --- Decay (prevents overfitting & footprint) ---
    decay = max(0.85, decay * 0.995);
    potency *= decay;

    // --- EDGELESS exponent ---
    edgeless = _computeEdgeless();
  }

  /// 🧮 Measures how cleanly deviation converts to movement
  double _computeEdgeEfficiency() {
    if (volatility == 0) return 0.0;

    double efficiency =
        (momentum.abs() / (volatility + 0.00001)) * decay;

    return efficiency.clamp(0.0, 5.0);
  }

  /// 🧠 EDGELESS = self-validating opportunity state
  double _computeEdgeless() {
    return log(1 + potency.abs()) * edgeEfficiency;
  }

  /// 🚦 Trade readiness state (used later)
  bool get isActive {
    return edgeless > 0.8 && edgeEfficiency > 0.6;
  }

  /// 🔒 Risk-aware leverage gate
  double get leverageFactor {
    return (edgeEfficiency * edgeless).clamp(0.5, 10.0);
  }
}
