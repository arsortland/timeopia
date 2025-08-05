import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/music_service.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  void initState() {
    super.initState();
    // Resume background music when entering collection page (if no timer is active)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MusicService.startBackgroundMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background layer with reduced blur effect
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background/background2.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3), // Reduced white overlay
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10.0,
                    sigmaY: 10.0,
                  ), // Reduced blur
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ),
          // Main content
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Collection'),
              backgroundColor: Colors.deepPurple.withOpacity(0.8),
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      MusicService.toggleMusic();
                    });
                  },
                  icon: Icon(
                    MusicService.isMusicEnabled
                        ? Icons.music_note
                        : Icons.music_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.collections_outlined,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Collection Coming Soon!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Complete timer sessions to unlock rewards',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
