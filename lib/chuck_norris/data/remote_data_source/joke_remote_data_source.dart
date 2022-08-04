import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';

part 'joke_remote_data_source_impl.dart';

abstract class JokeRemoteDataSource {
  const JokeRemoteDataSource();

  Future<JokeModel> getRandomJoke();
}
