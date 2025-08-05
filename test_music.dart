// Simple test to check if music service works
import 'lib/services/music_service.dart';

void main() async {
  print('Testing MusicService...');

  try {
    await MusicService.initialize();
    print('Initialization complete');

    await Future.delayed(Duration(milliseconds: 500));

    print('Attempting to start background music...');
    await MusicService.startBackgroundMusic();

    print('Music should be playing now. Waiting 3 seconds...');
    await Future.delayed(Duration(seconds: 3));

    print('Stopping music...');
    await MusicService.stopBackgroundMusic();

    print('Test complete');
  } catch (e) {
    print('Error in test: $e');
  }
}
