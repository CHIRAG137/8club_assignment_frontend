import 'package:club8_dev/widgets/customNavigationButton.dart';
import 'package:club8_dev/widgets/customStampLikeCardWidget.dart';
import 'package:club8_dev/widgets/customTextField.dart';
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
  double textFieldHeight = 240; // Default height for the TextField
  double textSize = 20; // Default text size
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    fetchExperiences();
    // Listen to text changes
    _textController.addListener(() {
      setState(() {}); // Rebuild the widget on text change
    });
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          // Adjust height and text size when the keyboard opens
          setState(() {
            textFieldHeight = 120; // Decrease height when keyboard opens
            textSize = 16; // Decrease text size when keyboard opens
          });
        } else {
          // Reset height and text size when the keyboard closes
          setState(() {
            textFieldHeight = 240; // Reset height
            textSize = 20; // Reset text size
          });
        }
      });
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
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What kind of hotspots do you want to host?",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: textSize),
              ),
              SizedBox(
                height: 12,
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
              SizedBox(
                height: 12,
              ),
              CustomTextField(
                controller: _textController,
                focusNode: _focusNode,
                textFieldHeight: textFieldHeight,
                textSize: textSize,
                hintText: 'Describe your perfect hotspot',
              ),
              SizedBox(
                height: 12,
              ),
              // Button below the TextField
              GradientButton(
                buttonText: "Next",
                icon: Icons.arrow_forward, // Optional icon
                controller: _textController,
                onPressed: () {
                  // Handle button press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
