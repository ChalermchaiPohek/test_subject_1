enum CurrencyUnit {
  wei(0),
  kwei(3),
  mwei(6),
  gwei(9),
  szabo(12),
  finney(15),
  ether(18),
  kether(21),
  mether(24),
  gether(27),
  tether(30);

  final int power;
  const CurrencyUnit(this.power);

  BigInt get _factor => BigInt.from(10).pow(power);
  BigInt toWei(BigInt value) => value * _factor;
  double fromWei(BigInt wei) => wei / _factor;

  String get unit {
    switch (this) {
      case CurrencyUnit.wei:
        return "Wei";
      case CurrencyUnit.kwei:
        return "KWei";
      case CurrencyUnit.mwei:
        return "MWei";
      case CurrencyUnit.gwei:
        return "GWei";
      case CurrencyUnit.szabo:
        return "Szabo";
      case CurrencyUnit.finney:
        return "Finney";
      case CurrencyUnit.ether:
        return "Ether";
      case CurrencyUnit.kether:
        return "KEther";
      case CurrencyUnit.mether:
        return "MEther";
      case CurrencyUnit.gether:
        return "GEther";
      case CurrencyUnit.tether:
        return "TEther";
    }
  }

  /// TODO: change to fetch from API.
  static double toUSD(BigInt wei) {
    final double eth = CurrencyUnit.ether.fromWei(wei);
    return eth * 4485.64;
  }
}