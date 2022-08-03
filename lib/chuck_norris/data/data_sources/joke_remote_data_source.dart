import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';

abstract class JokeRemoteDataSource {
  const JokeRemoteDataSource();

  Future<JokeModel> getRandomJoke();
}
