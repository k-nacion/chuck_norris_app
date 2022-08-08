import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chuck_norris_app/chuck_norris/domain/use_cases/get_random_joke_use_case.dart';
import 'package:chuck_norris_app/core/errors/failures.dart';
import 'package:equatable/equatable.dart';

part 'chuck_norris_event.dart';
part 'chuck_norris_state.dart';

class ChuckNorrisBloc extends Bloc<ChuckNorrisEvent, ChuckNorrisState> {
  final GetRandomJokeUseCase _getRandomJokeUseCase;

  ChuckNorrisBloc({required GetRandomJokeUseCase getRandomJokeUseCase})
      : _getRandomJokeUseCase = getRandomJokeUseCase,
        super(const ChuckNorrisState_Empty()) {
    on<ChuckNorrisEvent_FetchData>(_mapFetchDataToState);
  }

  FutureOr<void> _mapFetchDataToState(
    ChuckNorrisEvent_FetchData event,
    Emitter<ChuckNorrisState> emit,
  ) async {
    emit(const ChuckNorrisState_Loading());

    final randomJoke = await _getRandomJokeUseCase.call();
    await randomJoke.fold(
      (failure) => Future(() {
        if (failure is NoJokeFailure) {
          emit(const ChuckNorrisState_Error(message: 'No joke yet.'));
        } else if (failure is UnableToCacheFailure) {
          emit(const ChuckNorrisState_Error(message: 'Unable to save joke offline.'));
        }
      }),
      (success) => Future(() async {
        emit(ChuckNorrisState_Loaded(joke: success.value));
      }),
    );
  }
}
