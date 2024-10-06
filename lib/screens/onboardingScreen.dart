import 'dart:math';
import 'package:club8_dev/widgets/customRecordingButton.dart';
import 'package:club8_dev/widgets/customRecordingWaveWidget.dart';
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
  late final AudioRecorder _audioRecorder;
  String? _audioPath;
  final TextEditingController _textController =
      TextEditingController(); // Add controller for TextField
  double textFieldHeight = 240; // Default height for the TextField
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
            textFieldHeight = 240; // Reset height
            textSize = 20; // Reset text size
          });
        }
      });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _textController.dispose(); // Dispose the TextEditingController
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // TextField added here
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: textFieldHeight, // Adjust height dynamically
              child: TextField(
                controller: _textController,
                focusNode: _focusNode, // Attach FocusNode
                maxLength: 250, // Character limit
                maxLines: null, // Allows multi-line input
                expands: true, // Allows TextField to expand
                style: TextStyle(fontSize: textSize), // Adjust text size
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Remove border
                    borderRadius:
                        BorderRadius.all(Radius.circular(15)), // Radius
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(15)), // Radius
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.all(Radius.circular(15)), // Radius
                  ),
                  labelText: 'Describe your perfect hotspots',
                  filled: true,
                  fillColor:
                      Color.fromARGB(255, 71, 71, 71), // Background color
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isRecording) const CustomRecordingWaveWidget(),
          const SizedBox(height: 16),
          CustomRecordingButton(
            isRecording: isRecording,
            onPressed: () => _record(),
          ),
        ],
      ),
    );
  }
}
