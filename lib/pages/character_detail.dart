import 'package:flutter/material.dart';

class CharacterDetailPage extends StatelessWidget {
  final int characterIndex;
  final String characterGif;

  const CharacterDetailPage({
    super.key,
    required this.characterIndex,
    required this.characterGif,
  });

  // Perfect base values (safe values that worked perfectly)
  static const double baseOffsetX = 39.0; // Restored original working offset
  static const double baseOffsetY = 33.0; // Restored original working offset
  static const double scale = 2.5; // Smaller scale for container viewing
  static const double widthFactor = 0.2; // 1/5
  static const double heightFactor = 0.25; // 1/4

  // Calculated offset patterns (using the safe proven values)
  static const double xOffsetPattern = -301.0; // Original proven X difference
  static const double yOffsetPattern = -275.0; // Y offset as requested

  static const int totalRows = 4;
  static const int totalColumns = 5;

  // Calculate offset for specific row and column
  double calculateXOffset(int column) {
    return baseOffsetX + (column * xOffsetPattern);
  }

  double calculateYOffset(int row) {
    return baseOffsetY + (row * yOffsetPattern);
  }

  // Get border color for animation variety
  Color getBorderColor(int row, int col) {
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
      Colors.yellowAccent,
      Colors.redAccent,
      Colors.blueAccent,
    ];
    return colors[(row * 5 + col) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Character $characterIndex - All Animations'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Character header
            Text(
              'Character $characterIndex',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '4 Rows × 5 Columns = 20 Animations',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // Animation Grid organized by rows
            for (int row = 0; row < totalRows; row++) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Row ${row + 1}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Row of animations
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 animations per row for better viewing
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: totalColumns,
                itemBuilder: (context, colIndex) {
                  return AnimationCard(
                    characterIndex: characterIndex,
                    characterGif: characterGif,
                    row: row,
                    column: colIndex,
                    offsetX: calculateXOffset(colIndex),
                    offsetY: calculateYOffset(row),
                    borderColor: getBorderColor(row, colIndex),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }
}

class AnimationCard extends StatelessWidget {
  final int characterIndex;
  final String characterGif;
  final int row;
  final int column;
  final double offsetX;
  final double offsetY;
  final Color borderColor;

  const AnimationCard({
    super.key,
    required this.characterIndex,
    required this.characterGif,
    required this.row,
    required this.column,
    required this.offsetX,
    required this.offsetY,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.05),
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Animation label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: borderColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(13),
                topRight: Radius.circular(13),
              ),
            ),
            child: Text(
              'Animation ${row + 1}-${column + 1}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: borderColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Animation display
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: GifCropWidget(
                    gifPath: 'assets/models/Char $characterIndex/$characterGif',
                    targetRow: row,
                    targetColumn: column,
                    cropWidth: 130, // Slightly larger crop area
                    cropHeight: 130,
                    offsetX: offsetX,
                    offsetY: offsetY,
                    scale: 4.8, // Better scale for visibility
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable GIF Crop Widget
class GifCropWidget extends StatelessWidget {
  final String gifPath;
  final int targetRow;
  final int targetColumn;
  final double cropWidth;
  final double cropHeight;
  final double offsetX;
  final double offsetY;
  final double scale;

  const GifCropWidget({
    super.key,
    required this.gifPath,
    required this.targetRow,
    required this.targetColumn,
    this.cropWidth = 100,
    this.cropHeight = 100,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.scale = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cropWidth,
      height: cropHeight,
      child: ClipRect(
        child: Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topLeft,
            child: Align(
              alignment: Alignment.topLeft,
              widthFactor: 0.2, // 1/5
              heightFactor: 0.25, // 1/4
              child: Image.asset(gifPath, fit: BoxFit.none),
            ),
          ),
        ),
      ),
    );
  }
}
