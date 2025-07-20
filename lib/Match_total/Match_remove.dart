class MatchEvent {
  final String startTime;
  final String state;
  final String team1;
  final String team2;
  final int gameCount;

  MatchEvent({
    required this.startTime,
    required this.state,
    required this.team1,
    required this.team2,
    required this.gameCount,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      startTime: json['startTime'],
      state: json['state'],
      team1: json['match']['teams'][0]['name'],
      team2: json['match']['teams'][1]['name'],
      gameCount: json['match']['strategy']['count'],
    );
  }
}
