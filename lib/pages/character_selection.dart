import 'package:flutter/material.dart';
import 'character_detail.dart';

class CharacterSelectionPage extends StatelessWidget {
  const CharacterSelectionPage({super.key});

  // Character data with GIF file names
  static const Map<int, String> characterGifs = {
    1: 'Preview Character 1.gif',
    2: 'Preview Character 5.gif',
    3: 'Preview Character 9.gif',
    4: 'Preview Character 1.gif',
    5: 'Preview Character 5.gif',
    6: 'Preview Character 9.gif',
    7: 'Preview Character 1.gif',
    8: 'Preview Character 5.gif',
    9: 'Preview Character 9.gif',
    10: 'Preview Character 1.gif',
    11: 'Preview Character 5.gif',
    12: 'Preview Character 9.gif',
    13: 'Preview Character 1.gif',
    14: 'Preview Character 5.gif',
    15: 'Preview Character 9.gif',
    16: 'Preview Character 1.gif',
    17: 'Preview Character 5.gif',
    18: 'Preview Character 9.gif',
  };

  // Get character colors for visual variety
  Color getCharacterColor(int charIndex) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.amber,
      Colors.cyan,
      Colors.pink,
      Colors.indigo,
      Colors.lime,
      Colors.brown,
      Colors.grey,
      Colors.deepOrange,
      Colors.lightBlue,
      Colors.deepPurple,
      Colors.lightGreen,
      Colors.yellow,
    ];
    return colors[(charIndex - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Collection'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Choose a Character',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap any character to view all their animations',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Character Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 characters per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: 18,
                itemBuilder: (context, index) {
                  final charIndex = index + 1;
                  return CharacterButton(
                    characterIndex: charIndex,
                    characterGif: characterGifs[charIndex]!,
                    characterColor: getCharacterColor(charIndex),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailPage(
                            characterIndex: charIndex,
                            characterGif: characterGifs[charIndex]!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterButton extends StatelessWidget {
  final int characterIndex;
  final String characterGif;
  final Color characterColor;
  final VoidCallback onTap;

  const CharacterButton({
    super.key,
    required this.characterIndex,
    required this.characterGif,
    required this.characterColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: characterColor.withOpacity(0.1),
          border: Border.all(color: characterColor, width: 3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: characterColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Character preview (first animation)
            Expanded(
              flex: 3,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: characterColor, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/models/Char $characterIndex/$characterGif',
                    fit: BoxFit.cover, // Fill the preview area
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Character label
            Expanded(
              flex: 1,
              child: Text(
                'Char $characterIndex',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: characterColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
