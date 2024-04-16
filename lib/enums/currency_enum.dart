enum Currency {
  euro,
  indianRupee,
  usDollar,
}

extension CurrencyExtension on Currency {
  String get symbol {
    switch (this) {
      case Currency.euro:
        return "€";
      case Currency.indianRupee:
        return "₹";
      case Currency.usDollar:
        return "\$";
    }
  }

  String get code {
    switch (this) {
      case Currency.euro:
        return "EUR";
      case Currency.indianRupee:
        return "INR";
      case Currency.usDollar:
        return "USD";
    }
  }
}
