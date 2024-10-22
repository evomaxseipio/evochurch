/// Use [ButtonType] for apply predefine button color
enum ButtonType { secondary, warning, info, success, error, update, normal,   }

enum BackGroundType { dark, light, white }

/// Use to enumarate the types of offerts
enum OfferType {
  oneProducts(1),
  twoProducts(2),
  threeProducts(3),
  fourProducts(4),
  fiveProducts(5),
  sixProducts(6),
  sevenProducts(7),
  eightProducts(8),
  nineProducts(9),
  tenProducts(10),
  elevenProducts(11),
  twelveProducts(12);

  final int value;

  const OfferType(this.value);
 
}

///for Badge Package
enum BadgeType { warning, info, success, error }

enum ToastPosition { top, bottom, topLeft, topRight, bottomLeft, bottomRight }

/// Use [WaveType] for start position of wave
enum WaveType { start, end, center }

/// Use [Loadertype] for start position of wave
enum LoaderType {
  basicLoader,
  circleLoader,
  cubeGridLoader,
  doubleBounceLoader,
  fadingCircleLoader,
  pulseCircleLoader,
  rotatingCircleLoader,
  rotatingPlainLoader,
  spiningLinesLoader,
  waveLoader
}

// product_type.dart

enum ProductType {
  fruitsAndVegetables,
  dairy,
  meatsAndFish,
  bakeryAndPastry,
  beverages,
  cerealsAndGrains,
  snacksAndSweets,
  frozenProducts,
  cannedFoods,
  cleaningProducts,
  personalHygiene,
  alcoholicBeverages,
  petProducts,
  spicesAndCondiments,
  babyProducts
}

extension ProductTypeExtension on ProductType {
  String get displayName {
    return toString()
        .split('.')
        .last
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(0)}',
        )
        .trim()
        .replaceAll('And', '&');
  }
}


