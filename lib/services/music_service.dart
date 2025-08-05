import 'package:just_audio/just_audio.dart';

class MusicService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;
  static bool _isMusicEnabled = true;
  static bool _timerActive = false;
  static bool _isInitialized = false;

  // Initialize the music service
  static Future<void> initialize() async {
    try {
      // Pre-load the audio file during initialization
      await _player.setAsset(
        'assets/music/SayWhat - Scenery - 01 Kristiansand.mp3',
      );
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(0.3);

      // Wait for audio to be fully loaded and buffered
      await _player.load();

      // Minimal delay for audio system stability
      await Future.delayed(Duration(milliseconds: 100));

      _isInitialized = true;

      // Auto-start music after successful initialization
      Future.delayed(Duration(milliseconds: 200), () {
        startBackgroundMusic();
      });
    } catch (e) {
      print('Error initializing MusicService: $e');
      _isInitialized = false;
    }
  }

  // Start background music when no timer is active
  static Future<void> startBackgroundMusic() async {
    if (_isMusicEnabled && !_timerActive && !_isPlaying && _isInitialized) {
      try {
        // Start with very low volume to avoid clicking
        await _player.setVolume(0.0);

        // Since audio is pre-loaded and buffered, just play it
        await _player.play();
        _isPlaying = true;

        // Gradually fade in the volume to avoid clicking
        for (double volume = 0.0; volume <= 0.3; volume += 0.1) {
          await _player.setVolume(volume);
          await Future.delayed(Duration(milliseconds: 25));
        }
      } catch (e) {
        print('Error playing background music: $e');
        // Fallback: try to reload and play
        try {
          await _player.setAsset(
            'assets/music/SayWhat - Scenery - 01 Kristiansand.mp3',
          );
          await _player.load();
          await _player.setVolume(0.0);
          await _player.play();
          _isPlaying = true;

          // Fade in on fallback too
          for (double volume = 0.0; volume <= 0.3; volume += 0.1) {
            await _player.setVolume(volume);
            await Future.delayed(Duration(milliseconds: 25));
          }
        } catch (e2) {
          print('Fallback also failed: $e2');
        }
      }
    }
  }

  // Stop background music (when timer starts)
  static Future<void> stopBackgroundMusic() async {
    if (_isPlaying) {
      try {
        // Fade out quickly before stopping
        double currentVolume = 0.3;
        while (currentVolume > 0.0) {
          currentVolume -= 0.1;
          if (currentVolume < 0.0) currentVolume = 0.0;
          await _player.setVolume(currentVolume);
          await Future.delayed(Duration(milliseconds: 30));
        }

        await _player.stop();
        _isPlaying = false;
        print('Background music stopped with fade-out');
      } catch (e) {
        print('Error stopping background music: $e');
        // Force stop if fade fails
        await _player.stop();
        _isPlaying = false;
      }
    }
  }

  // Pause background music
  static Future<void> pauseBackgroundMusic() async {
    if (_isPlaying) {
      await _player.pause();
      _isPlaying = false;
    }
  }

  // Resume background music
  static Future<void> resumeBackgroundMusic() async {
    if (_isMusicEnabled && !_timerActive && !_isPlaying && _isInitialized) {
      try {
        // Start with low volume and fade in
        await _player.setVolume(0.0);
        await _player.play();
        _isPlaying = true;

        // Fade in
        for (double volume = 0.0; volume <= 0.3; volume += 0.1) {
          await _player.setVolume(volume);
          await Future.delayed(Duration(milliseconds: 25));
        }
      } catch (e) {
        print('Error resuming background music: $e');
        // Try to restart if resume fails
        startBackgroundMusic();
      }
    }
  }

  // Set timer active state
  static void setTimerActive(bool active) {
    _timerActive = active;
    if (active) {
      stopBackgroundMusic();
    } else {
      startBackgroundMusic();
    }
  }

  // Toggle music on/off
  static void toggleMusic() {
    _isMusicEnabled = !_isMusicEnabled;
    if (_isMusicEnabled && !_timerActive) {
      startBackgroundMusic();
    } else {
      stopBackgroundMusic();
    }
  }

  // Get current music state
  static bool get isMusicEnabled => _isMusicEnabled;
  static bool get isPlaying => _isPlaying;

  // Set volume (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  // Dispose of resources
  static Future<void> dispose() async {
    await _player.stop();
    await _player.dispose();
  }
}
