abstract class ExperienceState {}

class ExperienceInitial extends ExperienceState {}

class ExperienceLoading extends ExperienceState {}

class ExperienceLoaded extends ExperienceState {
  final List<dynamic> experiences;

  ExperienceLoaded(this.experiences);
}

class ExperienceError extends ExperienceState {
  final String message;

  ExperienceError(this.message);
}
