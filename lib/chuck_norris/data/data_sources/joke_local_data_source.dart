import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';

abstract class JokeLocalDataSource {
  Future<JokeModel> getCachedJoke();
  Future<void> cacheJoke(Joke joke);
}
