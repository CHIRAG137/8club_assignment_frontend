import 'dart:math';
import 'package:club8_dev/widgets/customRecordingButton.dart';
import 'package:club8_dev/widgets/customRecordingWaveWidget.dart';
import 'package:club8_dev/widgets/customTextField.dart';
import 'package:club8_dev/widgets/waveappbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool isRecording = false;
  bool showWaveWidget = false; // New variable to control wave widget visibility
  late final AudioRecorder _audioRecorder;
  String? _audioPath;
  final TextEditingController _textController =
      TextEditingController(); // Add controller for TextField
  double textFieldHeight = 360; // Default height for the TextField
  double textSize = 20; // Default text size
  late FocusNode _focusNode;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
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
            textFieldHeight = 360; // Reset height
            textSize = 20; // Reset text size
          });
        }
      });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _textController.dispose(); // Dispose the TextEditingController
    _focusNode.dispose(); // Dispose the FocusNode
    super.dispose();
  }

  String _generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(
      10,
      (index) => chars[random.nextInt(chars.length)],
      growable: false,
    ).join();
  }

  Future<void> _startRecording() async {
    try {
      debugPrint(
          '=========>>>>>>>>>>> RECORDING!!!!!!!!!!!!!!! <<<<<<===========');

      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');
      await _audioRecorder.start(
        const RecordConfig(
          // specify the codec to be `.wav`
          encoder: AudioEncoder.wav,
        ),
        path: filePath,
      );
    } catch (e) {
      debugPrint('ERROR WHILE RECORDING: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      String? path = await _audioRecorder.stop();

      setState(() {
        _audioPath = path!;
        showWaveWidget = true; // Show the wave widget after stopping recording
      });
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (isRecording == false) {
      final status = await Permission.microphone.request();

      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true;
          showWaveWidget = true; // Show wave widget when recording starts
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
        // TODO: handle this case
      }
    } else {
      await _stopRecording();

      setState(() {
        isRecording = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WaveAppBar(),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Why do you want to host with us?",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: textSize),
            ),
            SizedBox(height: 12),
            const Text(
              "Tell us about your intent and what motivates you to create experiences.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            CustomTextField(
              controller: _textController,
              focusNode: _focusNode,
              textFieldHeight: textFieldHeight,
              textSize: textSize,
              hintText: 'Start typing here',
            ),
            const SizedBox(height: 12),
            if (isRecording ||
                showWaveWidget) // Show the wave widget if recording or after
              CustomRecordingWaveWidget(
                isRecording: isRecording,
              ),
            const SizedBox(height: 16),
            CustomRecordingButton(
              isRecording: isRecording,
              onPressed: () => _record(),
            ),
          ],
        ),
      ),
    );
  }
}
