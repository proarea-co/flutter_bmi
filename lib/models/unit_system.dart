class UnitSystem {
  static const metric = UnitSystem._('Metric', 'kg', 1, 'cm', 1);
  static const imperial = UnitSystem._('Imperial', 'lbs', 0.453592, 'inch', 2.54);

  final String name;
  final String weightUnitName;
  final double weightUnitMultiplier;
  final String lengthUnitName;
  final double lengthUnitMultiplier;

  const UnitSystem._(
    this.name,
    this.weightUnitName,
    this.weightUnitMultiplier,
    this.lengthUnitName,
    this.lengthUnitMultiplier,
  );
}
