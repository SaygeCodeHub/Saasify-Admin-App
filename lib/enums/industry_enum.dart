enum Industry {
  retail,
  foodAndBeverage,
  medical,
  services,
}

extension IndustryExtension on Industry {
  String get name {
    switch (this) {
      case Industry.retail:
        return "Retail";
      case Industry.foodAndBeverage:
        return "Food and Beverage";
      case Industry.medical:
        return "Healthcare";
      case Industry.services:
        return "Services";
    }
  }

  String get description {
    switch (this) {
      case Industry.retail:
        return "Selling consumer goods or services to customers through multiple channels of distribution.";
      case Industry.foodAndBeverage:
        return "Providing food services to customers in restaurants, cafes, or food delivery services.";
      case Industry.medical:
        return "Offering medical services, manufacture of medical equipment or drugs, provision of medical insurance.";
      case Industry.services:
        return "Offering intangible goods or services such as accounting, financial services, education, and other professional services.";
    }
  }
}
