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
  bool showWaveWidget = false;
  late final AudioRecorder _audioRecorder;
  String? _audioPath;
  final TextEditingController _textController = TextEditingController();
  double textFieldHeight = 360;
  double textSize = 20;
  late FocusNode _focusNode;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          setState(() {
            textFieldHeight = 120;
            textSize = 16;
          });
        } else {
          setState(() {
            textFieldHeight = 360;
            textSize = 20;
          });
        }
      });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _textController.dispose();
    _focusNode.dispose();
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
      String filePath = await getApplicationDocumentsDirectory()
          .then((value) => '${value.path}/${_generateRandomId()}.wav');
      await _audioRecorder.start(
        const RecordConfig(
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
        showWaveWidget = true;
      });
      debugPrint('=========>>>>>> PATH: $_audioPath <<<<<<===========');
    } catch (e) {
      debugPrint('ERROR WHILE STOP RECORDING: $e');
    }
  }

  void _record() async {
    if (!isRecording) {
      final status = await Permission.microphone.request();
      if (status == PermissionStatus.granted) {
        setState(() {
          isRecording = true;
          showWaveWidget = true;
        });
        await _startRecording();
      } else if (status == PermissionStatus.permanentlyDenied) {
        debugPrint('Permission permanently denied');
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
            const SizedBox(height: 12),
            const Text(
              "Tell us about your intent and what motivates you to create experiences.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _textController,
              focusNode: _focusNode,
              textFieldHeight: textFieldHeight,
              textSize: textSize,
              hintText: 'Start typing here',
            ),
            const SizedBox(height: 12),
            if (isRecording || showWaveWidget)
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
