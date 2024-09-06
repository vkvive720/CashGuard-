// beautiful_card.dart
import 'package:flutter/material.dart';

class BeautifulCard extends StatelessWidget {
  final String title; // Text to display
  final TextStyle titleStyle; // Style for the text
  final List<Color> gradientColors; // Gradient colors
  final double borderRadius; // Border radius
  final double height; // Card height
  final double width; // Card width
  final double elevation; // Elevation for shadow effect

  BeautifulCard({
    required this.title,
    required this.gradientColors,
    this.titleStyle = const TextStyle(
      // Default text style
      color: Colors.white,
      fontSize: 24,
    ),
    this.borderRadius = 20.0, // Default border radius
    this.height = 200.0, // Default height
    this.width = 300.0, // Default width
    this.elevation = 0.0, // Default elevation
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(borderRadius), // Use provided border radius
      ),
      elevation: elevation, // Use provided elevation
      child: Container(
        width: width, // Use provided width
        height: height, // Use provided height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors, // Use provided gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius:
              BorderRadius.circular(borderRadius), // Use provided border radius
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "assets/images/cash.png",
                color: Colors.white,
                height: 50,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                title, // Use provided title
                style: titleStyle, // Use provided text style
              ),
            ],
          ),
        ),
      ),
    );
  }
}
