import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DebugMusicPage extends StatefulWidget {
  @override
  _DebugMusicPageState createState() => _DebugMusicPageState();
}

class _DebugMusicPageState extends State<DebugMusicPage> {
  final AudioPlayer _player = AudioPlayer();
  String _status = 'Not initialized';

  Future<void> _initAndPlayMusic() async {
    try {
      setState(() {
        _status = 'Initializing...';
      });

      await _player.setAsset(
        'assets/music/SayWhat - Scenery - 01 Kristiansand.mp3',
      );
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(0.3);
      await _player.load();

      setState(() {
        _status = 'Loaded, starting playback...';
      });

      await _player.play();

      setState(() {
        _status = 'Playing!';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _stopMusic() async {
    try {
      await _player.stop();
      setState(() {
        _status = 'Stopped';
      });
    } catch (e) {
      setState(() {
        _status = 'Stop error: $e';
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug Music')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Status: $_status'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initAndPlayMusic,
              child: Text('Play Music'),
            ),
            ElevatedButton(onPressed: _stopMusic, child: Text('Stop Music')),
          ],
        ),
      ),
    );
  }
}
