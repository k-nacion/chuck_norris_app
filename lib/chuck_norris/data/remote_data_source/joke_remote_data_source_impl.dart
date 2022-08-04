part of 'joke_remote_data_source.dart';

class JokeRemoteDataSourceImpl implements JokeRemoteDataSource {
  final Client _client;

  const JokeRemoteDataSourceImpl({
    required Client client,
  }) : _client = client;

  @override
  Future<JokeModel> getRandomJoke() async {
    try {
      final response = await _client.read(Uri.https(CHUCK_NORRIS_AUTHORITY, CHUCK_NORRIS_UNENCODED_PATH));
      return JokeModel.fromMap(jsonDecode(response));
    } on ClientException {
      throw ServerException();
    }
  }
}
