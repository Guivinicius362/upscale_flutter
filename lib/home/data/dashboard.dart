class Dashboard {
  final int temperature;
  final int oxygen;
  final int beatRate;

  Dashboard({
    required this.temperature,
    required this.oxygen,
    required this.beatRate,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        temperature: json['temperature'] as int,
        oxygen: json['oxygen'] as int,
        beatRate: json['beat_rate'] as int,
      );
}
