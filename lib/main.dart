import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe Categories',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const Lab3Layout(),
    );
  }
}



class Lab3Layout extends StatelessWidget {
  const Lab3Layout({super.key});

  // Helper method to create the image Stack (used for all image rows)
  Widget _buildImageStack(String assetName, String label, Alignment alignment) {
    // Check if the text is supposed to be placed below the image (for Course/Dessert)
    final bool isBottomAligned = alignment == Alignment.bottomCenter;
    const double imageRadius = 60.0; // INCREASED RADIUS for bigger size

    return Column(
      // Centers the label below the circular image
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: alignment,
          children: [
            // Using CircleAvatar for the circular frame effect on all images
            CircleAvatar(
              backgroundImage: AssetImage('images/$assetName'),
              radius: imageRadius, // Using the new, larger radius
            ),
            // Text is overlay in the center for 'BY MEAT'
            if (!isBottomAligned)
              Container(
                alignment: Alignment.center,
                // Using SizedBox to force the text to fit within the circle's bounds
                child: SizedBox(
                  width: imageRadius * 1.5,
                  height: imageRadius * 1.5,
                  child: Center(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Text is placed BELOW the image for 'BY COURSE' and 'BY DESSERT' (to match the image)
        if (isBottomAligned)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ),
      ],
    );
  }

  // Helper method to create the image rows
  Widget _buildImageRow(List<String> imagePaths, List<String> labels, Alignment alignment) {
    return Padding(
      // Reduced vertical padding slightly
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        // FIX: Changed from spaceAround to CENTER to group images closely together.
        mainAxisAlignment: MainAxisAlignment.center,
        // Adding a small horizontal gap between the images themselves
        children: List.generate(imagePaths.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0), // Adds a 5-pixel gap on both sides of each image
            child: _buildImageStack(imagePaths[index], labels[index], alignment),
          );
        }),
      ),
    );
  }


  // Helper method for category titles
  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      // Keeping SingleChildScrollView to prevent overflow
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // ... (Title and Description widgets) ...
              const Text(
                'BROWSE CATEGORIES',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 24.0),
                child: Text(
                  'Not sure about exactly which recipe you\'re looking for? Do a search, or dive into our most popular categories.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),

              // 2. BY MEAT Category
              _buildCategoryTitle('BY MEAT'),
              _buildImageRow(
                ['beef.png', 'chicken.png', 'pork.png', 'seafood.png'],
                ['BEEF', 'CHICKEN', 'PORK', 'SEAFOOD'],
                Alignment.center,
              ),

              // 3. BY COURSE Category
              _buildCategoryTitle('BY COURSE'),
              _buildImageRow(
                [
                  'main_dishes.png',
                  'salad.png',
                  'side_dishes.png',
                  'crockpot.png'
                ],
                ['Main Dishes', 'Salad Recipes', 'Side Dishes', 'Crockpot'],
                Alignment.bottomCenter,
              ),

              // 4. BY DESSERT Category
              _buildCategoryTitle('BY DESSERT'),
              _buildImageRow(
                ['ice_cream.png', 'brownies.png', 'pies.png', 'cookies.png'],
                ['Ice Cream', 'Brownies', 'Pies', 'Cookies'],
                Alignment.bottomCenter,
              ),
            ],
          ),
        ),
      ),
    );
  }
  }