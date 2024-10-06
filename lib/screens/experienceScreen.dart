import 'package:club8_dev/widgets/waveappbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'dart:math'; // Import for generating random numbers
import 'package:http/http.dart' as http;

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  List<dynamic> experiences = [];
  bool isLoading = true;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchExperiences();
  }

  Future<void> fetchExperiences() async {
    final response =
        await http.get(Uri.parse('https://staging.cos.8club.co/experiences'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        experiences = data['data']['experiences'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load experiences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_back_sharp,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
        title: WaveAppBar(
          waveColor: Colors.purple.shade900.withOpacity(0.9), // Half blue
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "What kind of hotspots do you want to host?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: experiences.map((experience) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: StampLikeCard(
                                experience: experience,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 240, // Increase the height here
                  child: TextField(
                    controller: _textController,
                    maxLength: 250, // Character limit
                    maxLines: null, // Allows multi-line input
                    expands:
                        true, // Allows TextField to expand and fill the given height
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide.none, // Remove the visible border
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)), // Apply border radius
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border on focus
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)), // Keep same radius on focus
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border when enabled
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)), // Apply radius
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border on error
                        borderRadius: BorderRadius.all(
                            Radius.circular(15)), // Apply radius
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, // No border when disabled
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)), // Apply radius
                      ),
                      labelText: 'Describe your perfect hotspots',
                      filled: true, // Enable background color
                      fillColor: Color.fromARGB(
                          255, 71, 71, 71), // Set the background color to grey
                    ),
                  ),
                ),
              ),
              // Button below the TextField
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 4.0), // Adjust vertical padding as needed
                child: Container(
                  width: double.infinity, // Full screen width
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black, // Left color
                        Colors.grey, // Center color
                        Colors.black, // Right color
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    border: Border.all(
                        color: Colors.white, width: 0.5), // White border
                  ),
                  child: TextButton(
                    onPressed: () {
                      // Handle button press
                    },
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Center the content
                      children: [
                        Icon(
                          Icons.arrow_forward, // Icon on the button
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Space between icon and text
                        Text(
                          "Next",
                          style: TextStyle(
                            color: Colors.white, // Text color
                            fontSize: 16, // Text size
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StampLikeCard extends StatefulWidget {
  final dynamic experience;

  const StampLikeCard({Key? key, required this.experience}) : super(key: key);

  @override
  _StampLikeCardState createState() => _StampLikeCardState();
}

class _StampLikeCardState extends State<StampLikeCard> {
  bool isSelected = false; // Track the selection state
  Color selectedColor = Colors.black; // Initial color

  // Function to generate a random color
  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate a random tilt angle between -15 and +15 degrees
    final random = Random();
    final double tiltAngle =
        (random.nextInt(31) - 10) * (pi / 180); // Convert degrees to radians
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the selection state
          isSelected = !isSelected;
          if (isSelected) {
            selectedColor = getRandomColor();
          } else {
            selectedColor = Colors.black;
          }
        });
      },
      child: Transform.rotate(
        angle: tiltAngle, // Apply the random tilt
        child: ClipPath(
          clipper: TicketClipper(),
          child: Container(
            color: Colors.white,
            height: 130,
            width: 130,
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 120,
                  width: 120,
                  color: selectedColor, // Use the dynamic color
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          widget.experience['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: 24,
                        left: 20,
                        right: 20,
                        child: Image.network(
                          widget.experience['icon_url'],
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Clipper to create the stamp (ticket-like) effect
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    const double semiCircleRadius = 10.0; // Radius of each semicircle
    const double gapLength =
        15.0; // Length of the straight line between semicircles

    // Start at the top-left corner
    path.moveTo(0, 0);

    // Top side: 4 semicircles with gaps between them
    for (double i = 0; i < size.width; i += 2 * semiCircleRadius + gapLength) {
      path.lineTo(i + gapLength, 0);
      path.arcToPoint(
        Offset(i + gapLength + 2 * semiCircleRadius, 0),
        radius: Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    // Right side: 4 semicircles with gaps between them
    for (double i = 0; i < size.height; i += 2 * semiCircleRadius + gapLength) {
      path.lineTo(size.width, i + gapLength);
      path.arcToPoint(
        Offset(size.width, i + gapLength + 2 * semiCircleRadius),
        radius: Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    // Bottom side: 4 semicircles with gaps between them
    for (double i = size.width; i > 0; i -= 2 * semiCircleRadius + gapLength) {
      path.lineTo(i - gapLength, size.height);
      path.arcToPoint(
        Offset(i - gapLength - 2 * semiCircleRadius, size.height),
        radius: Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    // Left side: 4 semicircles with gaps between them
    for (double i = size.height; i > 0; i -= 2 * semiCircleRadius + gapLength) {
      path.lineTo(0, i - gapLength);
      path.arcToPoint(
        Offset(0, i - gapLength - 2 * semiCircleRadius),
        radius: Radius.circular(semiCircleRadius),
        clockwise: false,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
