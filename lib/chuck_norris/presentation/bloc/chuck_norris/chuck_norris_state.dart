part of 'chuck_norris_bloc.dart';

abstract class ChuckNorrisState extends Equatable {
  const ChuckNorrisState();

  @override
  List<Object?> get props => [];
}

class ChuckNorrisState_Empty extends ChuckNorrisState {
  const ChuckNorrisState_Empty();
}

class ChuckNorrisState_Loading extends ChuckNorrisState {
  const ChuckNorrisState_Loading();
}

class ChuckNorrisState_Loaded extends ChuckNorrisState {
  final String joke;

  const ChuckNorrisState_Loaded({
    required this.joke,
  });

  @override
  List<String> get props => [joke];
}

class ChuckNorrisState_Error extends ChuckNorrisState {
  final String? message;

  const ChuckNorrisState_Error({
    this.message,
  });

  @override
  List<Object?> get props => [message];
}
