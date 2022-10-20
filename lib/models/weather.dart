class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;
  final String country;
  final String city;
  final double temp;

  Weather(
      {required this.id,
      required this.main,
      required this.description,
      required this.icon,
      required this.country,
      required this.temp,
      required this.city});
}
