import 'dart:convert';

import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:chuck_norris_app/core/errors/exception.dart';
import 'package:http/http.dart';

part 'joke_remote_data_source_const.dart';
part 'joke_remote_data_source_impl.dart';

abstract class JokeRemoteDataSource {
  const JokeRemoteDataSource();

  Future<JokeModel> getRandomJoke();
}
