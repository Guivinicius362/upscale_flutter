class Dashboard {
  final int temperature;
  final int oxygen;
  final int beatRate;

  Dashboard({
    required this.temperature,
    required this.oxygen,
    required this.beatRate,
  });

  factory Dashboard.fromJson(Map<String, Object> json) => Dashboard(
        temperature: json['temperature'] as int,
        oxygen: json['temperature'] as int,
        beatRate: json['temperature'] as int,
      );
}
