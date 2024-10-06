import 'package:club8_dev/blocs/experience_screen_bloc/experience_bloc.dart';
import 'package:club8_dev/blocs/experience_screen_bloc/experience_event.dart';
import 'package:club8_dev/blocs/experience_screen_bloc/experience_state.dart';
import 'package:club8_dev/screens/onboardingScreen.dart';
import 'package:club8_dev/widgets/customNavigationButton.dart';
import 'package:club8_dev/widgets/customStampLikeCardWidget.dart';
import 'package:club8_dev/widgets/customTextField.dart';
import 'package:club8_dev/widgets/waveappbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final TextEditingController _textController = TextEditingController();
  double textFieldHeight = 240;
  double textSize = 20;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {});
    });
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() {
          textFieldHeight = _focusNode.hasFocus ? 120 : 240;
          textSize = _focusNode.hasFocus ? 16 : 20;
        });
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExperienceBloc()..add(FetchExperiences()),
      child: Scaffold(
        appBar: const WaveAppBar(),
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
                const SizedBox(height: 12),
                BlocBuilder<ExperienceBloc, ExperienceState>(
                  builder: (context, state) {
                    if (state is ExperienceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ExperienceLoaded) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: state.experiences.map((experience) {
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
                      );
                    } else if (state is ExperienceError) {
                      return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red)));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  textFieldHeight: textFieldHeight,
                  textSize: textSize,
                  hintText: 'Describe your perfect hotspot',
                ),
                const SizedBox(height: 12),
                GradientButton(
                  buttonText: "Next",
                  icon: Icons.arrow_forward,
                  controller: _textController,
                  onPressed: () {
                    print("Next button pressed");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecordingScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
