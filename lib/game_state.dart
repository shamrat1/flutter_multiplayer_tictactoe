class GameState {
  final String? gameID;
  final String? playerOneStatus;
  final String? playerTwoStatus;
  final int currentTurn;
  final List<String> state;
  final List<String> results;

  GameState({
    this.gameID,
    required this.currentTurn,
    required this.state,
    required this.results,
    this.playerOneStatus,
    this.playerTwoStatus,
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      gameID: json['gameID'],
      currentTurn: json['currentTurn'],
      state: List<String>.from(json['state']),
      results: List<String>.from(json['results']),
      playerOneStatus: json["playerOneStatus"],
      playerTwoStatus: json["playerTwoStatus"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameID': gameID,
      'currentTurn': currentTurn,
      'state': state,
      'results': results,
      'playerTwoStatus': playerTwoStatus,
      'playerOneStatus': playerOneStatus,
    };
  }

  GameState copyWith({
    String? gameID,
    int? currentTurn,
    List<String>? state,
    List<String>? results,
    String? playerTwoStatus,
    String? playerOneStatus,
  }) {
    return GameState(
      gameID: gameID ?? this.gameID,
      currentTurn: currentTurn ?? this.currentTurn,
      state: state ?? this.state,
      results: results ?? this.results,
      playerTwoStatus: playerTwoStatus ?? this.playerTwoStatus,
      playerOneStatus: playerOneStatus ?? this.playerOneStatus,
    );
  }
}
