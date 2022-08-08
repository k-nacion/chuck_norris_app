part of 'joke_local_data_source.dart';

class JokeLocalDataSourceImpl implements JokeLocalDataSource {
  final SharedPreferences _sharedPreferences;

  const JokeLocalDataSourceImpl({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  @override
  Future<JokeModel> getCachedJoke() async {
    final serializedJoke = _sharedPreferences.getString(CACHE_JOKE_KEY);

    if (serializedJoke == null) {
      throw NoJokeException();
    }

    return JokeModel.fromMap(jsonDecode(serializedJoke));
  }

  @override
  Future<void> cacheJoke(JokeModel jokeModel) async =>
      await _sharedPreferences.setString(CACHE_JOKE_KEY, jsonEncode(jokeModel.toMap()))
          ? {}
          : {throw UnableToCacheException()};
}
