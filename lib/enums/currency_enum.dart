enum Currency {
  euro,
  indianRupee,
  usDollar,
}

extension CurrencyExtension on Currency {
  String get name {
    switch (this) {
      case Currency.euro:
        return "Euro (Germany, Greece)";
      case Currency.indianRupee:
        return "Indian Rupee (India)";
      case Currency.usDollar:
        return "US Dollar (US)";
    }
  }

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
