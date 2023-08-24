class PlayGameMode {
  final bool isDuelMode;
  final String? p1Name;
  final String? p2Name;

  PlayGameMode.solo()
      : isDuelMode = false,
        p1Name = null,
        p2Name = null;

  PlayGameMode.duel({required this.p1Name, required this.p2Name})
      : isDuelMode = true;
}
