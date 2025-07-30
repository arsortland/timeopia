import 'package:flutter/material.dart';
import 'Timer.dart';
import 'collection.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true); // This makes it go back and forth
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Layer 1 - Static background (no movement)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use different scaling based on screen aspect ratio
                final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                
                // For very tall screens (like Pixel 9 XL), use fitHeight to scale larger
                // This will make the background bigger while maintaining aspect ratio
                if (screenAspectRatio < 0.6) {
                  return Image.asset(
                    'assets/background/Hills Layer 01.png',
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.center,
                  );
                } else {
                  return Image.asset(
                    'assets/background/Hills Layer 01.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  );
                }
              },
            ),
          ),

          // Layer 2 - Slight movement (same direction as main)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left:
                    ((_controller.value - 0.5) * 2) * 10 -
                    (MediaQuery.of(context).size.width *
                        0.05), // ±10 pixels movement, centered
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1, // 10% wider
                  height: MediaQuery.of(context).size.height,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                      
                      if (screenAspectRatio < 0.6) {
                        return Image.asset(
                          'assets/background/Hills Layer 02.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        );
                      } else {
                        return Image.asset(
                          'assets/background/Hills Layer 02.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),

          // Layer 3 - Opposite direction
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left:
                    -((_controller.value - 0.5) * 2) * 12 -
                    (MediaQuery.of(context).size.width *
                        0.05), // ±12 pixels opposite movement, centered
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1, // 10% wider
                  height: MediaQuery.of(context).size.height,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                      
                      if (screenAspectRatio < 0.6) {
                        return Image.asset(
                          'assets/background/Hills Layer 03.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        );
                      } else {
                        return Image.asset(
                          'assets/background/Hills Layer 03.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),

          // Layer 4 - Same direction but faster
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left:
                    ((_controller.value - 0.5) * 2) * 18 -
                    (MediaQuery.of(context).size.width *
                        0.05), // ±18 pixels movement, centered
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1, // 10% wider
                  height: MediaQuery.of(context).size.height,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                      
                      if (screenAspectRatio < 0.6) {
                        return Image.asset(
                          'assets/background/Hills Layer 04.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        );
                      } else {
                        return Image.asset(
                          'assets/background/Hills Layer 04.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),

          // Layer 5 - Opposite direction, faster
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left:
                    -((_controller.value - 0.5) * 2) * 22 -
                    (MediaQuery.of(context).size.width *
                        0.05), // ±22 pixels opposite movement, centered
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1, // 10% wider
                  height: MediaQuery.of(context).size.height,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                      
                      if (screenAspectRatio < 0.6) {
                        return Image.asset(
                          'assets/background/Hills Layer 05.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        );
                      } else {
                        return Image.asset(
                          'assets/background/Hills Layer 05.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),

          // Layer 6 - Fastest movement (same direction as main)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                left:
                    ((_controller.value - 0.5) * 2) * 28 -
                    (MediaQuery.of(context).size.width *
                        0.05), // ±28 pixels movement, centered
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.1, // 10% wider
                  height: MediaQuery.of(context).size.height,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenAspectRatio = constraints.maxWidth / constraints.maxHeight;
                      
                      if (screenAspectRatio < 0.6) {
                        return Image.asset(
                          'assets/background/Hills Layer 06.png',
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center,
                        );
                      } else {
                        return Image.asset(
                          'assets/background/Hills Layer 06.png',
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),

          // Content overlay with better visibility
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "WELCOME TO TIMEOPIA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], // Mellow light background
                    foregroundColor: Colors.black, // Black text
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    elevation: 3,
                    shadowColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Slightly rounded edges
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Timerpage()),
                    );
                  },
                  child: const Text("Focus"),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200], // Mellow light background
                    foregroundColor: Colors.black, // Black text
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    elevation: 3,
                    shadowColor: Colors.black.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Slightly rounded edges
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CollectionPage()),
                    );
                  },
                  child: const Text("Collection"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
