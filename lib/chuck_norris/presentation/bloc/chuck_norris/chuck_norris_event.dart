part of 'chuck_norris_bloc.dart';

abstract class ChuckNorrisEvent extends Equatable {
  const ChuckNorrisEvent();

  @override
  List<Object?> get props => [];
}

class ChuckNorrisEvent_FetchData extends ChuckNorrisEvent {}
