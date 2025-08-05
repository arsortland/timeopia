import 'package:flutter/material.dart';
import 'Timer.dart';
import 'collection.dart';
import '../services/music_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.repeat(reverse: true);

    // Start background music when home page loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 200));
      MusicService.startBackgroundMusic();
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background layer - bottom z-index
          Positioned.fill(
            child: Image.asset(
              'assets/background/background2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Logo layer - positioned in top 1/5 of screen with animated glow
          Positioned(
            top:
                MediaQuery.of(context).size.height *
                0.03, // Start at 3% from top (moved up slightly)
            left: 0,
            right: 0,
            child: Container(
              height:
                  MediaQuery.of(context).size.height *
                  0.28, // Increased from 20% to 28% of screen height
              padding: EdgeInsets.symmetric(
                horizontal:
                    MediaQuery.of(context).size.width *
                    0.08, // Reduced padding to 8% for more logo space
              ),
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow effect positioned behind the logo
                      Container(
                        height:
                            MediaQuery.of(context).size.height *
                            0.28 *
                            0.4, // 40% of logo height for middle section
                        width:
                            MediaQuery.of(context).size.width *
                            0.6, // 60% of available width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ), // Rounded edges for the glow
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(
                                _glowAnimation.value * 0.4,
                              ),
                              blurRadius: 20.0 * _glowAnimation.value,
                              spreadRadius: 3.0 * _glowAnimation.value,
                            ),
                            BoxShadow(
                              color: Colors.blue.withOpacity(
                                _glowAnimation.value * 0.2,
                              ),
                              blurRadius: 35.0 * _glowAnimation.value,
                              spreadRadius: 6.0 * _glowAnimation.value,
                            ),
                          ],
                        ),
                      ),
                      // Main logo image on top
                      Image.asset(
                        'assets/background/logoname-removebg.png',
                        fit: BoxFit.contain,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Content overlay with better visibility
          Positioned(
            bottom:
                MediaQuery.of(context).size.height *
                0.02, // Position from bottom (moved even lower)
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play button (was Focus)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Timerpage()),
                    );
                  },
                  child: Container(
                    width: 350,
                    height: 140,
                    child: Image.asset(
                      'assets/buttons/Playbtn.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                // Collection button
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CollectionPage()),
                    );
                  },
                  child: Container(
                    width: 350,
                    height: 140,
                    child: Image.asset(
                      'assets/buttons/Collectionbtn.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
