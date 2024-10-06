import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'experience_event.dart';
import 'experience_state.dart';

class ExperienceBloc extends Bloc<ExperienceEvent, ExperienceState> {
  ExperienceBloc() : super(ExperienceInitial()) {
    // Register the event handler for FetchExperiences
    on<FetchExperiences>((event, emit) async {
      emit(ExperienceLoading());

      try {
        final response = await http.get(Uri.parse('https://staging.cos.8club.co/experiences'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          emit(ExperienceLoaded(data['data']['experiences']));
        } else {
          emit(ExperienceError('Failed to load experiences'));
        }
      } catch (e) {
        emit(ExperienceError('An error occurred: $e'));
      }
    });
  }
}
