import 'package:equatable/equatable.dart';

class Joke extends Equatable {
  final String id;
  final String url;
  final String value;

  const Joke({
    required this.id,
    required this.url,
    required this.value,
  });

  @override
  List<Object> get props => [id, url, value];

  @override
  String toString() {
    return 'Joke{id: $id, url: $url, value: $value}';
  }
}
