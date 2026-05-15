enum CurrencyUnit {
  bitcoin,
  satoshi;

  String get label => switch (this) {
    CurrencyUnit.bitcoin => 'BTC',
    CurrencyUnit.satoshi => 'sat',
  };

  CurrencyUnit get toggled => switch (this) {
    CurrencyUnit.bitcoin => CurrencyUnit.satoshi,
    CurrencyUnit.satoshi => CurrencyUnit.bitcoin,
  };
}
