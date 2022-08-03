import 'package:chuck_norris_app/chuck_norris/domain/entities/joke.dart';

class JokeModel extends Joke {
  const JokeModel({required super.id, required super.url, required super.value});

  Map<String, dynamic> toMap() {
    return {
      'id': super.id,
      'url': super.url,
      'value': super.value,
    };
  }

  factory JokeModel.fromMap(Map<String, dynamic> map) {
    return JokeModel(
      id: map['id'] as String,
      url: map['url'] as String,
      value: map['value'] as String,
    );
  }
}
