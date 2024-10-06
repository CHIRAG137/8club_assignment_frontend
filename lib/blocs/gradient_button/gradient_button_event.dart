part of 'gradient_button_bloc.dart';

abstract class GradientButtonEvent {}

class TextChanged extends GradientButtonEvent {
  final String text;

  TextChanged(this.text);
}

