class Dashboard {
  final num temperature;
  final num oxygen;
  final num beatRate;

  Dashboard({
    required this.temperature,
    required this.oxygen,
    required this.beatRate,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        temperature: json['temperature'] as num,
        oxygen: json['oxygen'] as num,
        beatRate: json['beat_rate'] as num,
      );
}
