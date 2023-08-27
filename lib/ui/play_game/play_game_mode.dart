class PlayGameMode {
  final bool isSoloMode;
  final String p1Name;
  final String p2Name;

  PlayGameMode.solo()
      : isSoloMode = true,
        p1Name = "",
        p2Name = "";

  PlayGameMode.duel({required this.p1Name, required this.p2Name}) : isSoloMode = false;
}
