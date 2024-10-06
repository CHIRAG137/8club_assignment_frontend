import 'package:bloc/bloc.dart';
part 'gradient_button_event.dart';
part 'gradient_button_state.dart';

class GradientButtonBloc extends Bloc<GradientButtonEvent, GradientButtonState> {
  GradientButtonBloc() : super(GradientButtonInitial());

  @override
  Stream<GradientButtonState> mapEventToState(GradientButtonEvent event) async* {
    if (event is TextChanged) {
      if (event.text.isEmpty) {
        yield GradientButtonDisabled();
      } else {
        yield GradientButtonEnabled();
      }
    }
  }
}
