class Gender {
  static const male = Gender._('Male');
  static const female = Gender._('Female');

  final String name;

  const Gender._(this.name);
}
