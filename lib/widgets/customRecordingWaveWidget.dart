import 'dart:async';
import 'package:club8_dev/Utils/colors.dart';
import 'package:club8_dev/Utils/spacing.dart';
import 'package:flutter/material.dart';

class CustomRecordingWaveWidget extends StatefulWidget {
  final bool isRecording;

  const CustomRecordingWaveWidget({super.key, required this.isRecording});

  @override
  State<CustomRecordingWaveWidget> createState() => _RecordingWaveWidgetState();
}

class _RecordingWaveWidgetState extends State<CustomRecordingWaveWidget> {
  final List<double> _heights = [
    0.02,
    0.03,
    0.05,
    0.04,
    0.02,
    0.03,
    0.02,
    0.06,
    0.04,
    0.03,
    0.03,
    0.02,
    0.06,
    0.04,
    0.03,
    0.03,
    0.02,
    0.06,
    0.04,
    0.03,
    0.03,
    0.02,
    0.06,
    0.04,
    0.03,
  ];

  Timer? _waveTimer;
  Timer? _elapsedTimeTimer;
  int _elapsedSeconds = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.isRecording) {
      _startAnimating();
      _startElapsedTimer();
    }
  }

  @override
  void didUpdateWidget(CustomRecordingWaveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRecording && !widget.isRecording) {
      _stopTimers();
      setState(() {
        _isCompleted = true;
      });
    } else if (!oldWidget.isRecording && widget.isRecording) {
      _startAnimating();
      _startElapsedTimer();
      setState(() {
        _isCompleted = false;
      });
    }
  }

  @override
  void dispose() {
    _stopTimers();
    super.dispose();
  }

  void _startAnimating() {
    _waveTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        _heights.add(_heights.removeAt(0));
      });
    });
  }

  void _startElapsedTimer() {
    _elapsedTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimers() {
    _waveTimer?.cancel();
    _elapsedTimeTimer?.cancel();
  }

  void _deleteAudio() {
    setState(() {
      _isCompleted = false;
      _elapsedSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Spacing.medium),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.backgroundGradientStart,
            AppColors.backgroundGradientMiddle,
            AppColors.backgroundGradientEnd,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(
          color: AppColors.greyBorder,
          width: 0.2,
        ),
        borderRadius: BorderRadius.circular(Spacing.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isRecording ? "Recording Audio..." : "Audio Recorded",
                style: const TextStyle(color: AppColors.textGrey),
              ),
              if (_isCompleted)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: AppColors.iconColorWhite,
                    size: 18,
                  ),
                  onPressed: _deleteAudio,
                ),
            ],
          ),
          SizedBox(height: Spacing.small),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isCompleted = !_isCompleted;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.iconBackground,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(Spacing.small),
                  child: Icon(
                    widget.isRecording
                        ? Icons.mic
                        : _isCompleted
                            ? Icons.play_arrow_outlined
                            : Icons.check,
                    color: AppColors.iconColorWhite,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _heights.map((height) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 6,
                      height: MediaQuery.sizeOf(context).height * height,
                      margin: EdgeInsets.only(right: Spacing.small),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Text(
                _formatElapsedTime(),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.elapsedTimeTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatElapsedTime() {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
