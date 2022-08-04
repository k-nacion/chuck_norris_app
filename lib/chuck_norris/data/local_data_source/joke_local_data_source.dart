import 'dart:convert';

import 'package:chuck_norris_app/chuck_norris/data/models/joke_model.dart';
import 'package:chuck_norris_app/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'joke_local_data_source_consts.dart';
part 'joke_local_data_source_impl.dart';

abstract class JokeLocalDataSource {
  Future<JokeModel> getCachedJoke();
  Future<void> cacheJoke(JokeModel jokeModel);
}
