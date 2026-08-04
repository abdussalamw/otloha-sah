class PlayerServiceApp {
  static bool _isPlaying = false;

  static void stop() {
    _isPlaying = false;
  }

  static bool? isPlaying() {
    return _isPlaying;
  }

  static void setPlaying(bool playing) {
    _isPlaying = playing;
  }
}
