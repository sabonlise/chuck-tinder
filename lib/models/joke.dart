import 'package:json_annotation/json_annotation.dart';
part 'joke.g.dart';

@JsonSerializable()
class Joke {
  Joke(this.value, this.url, this.image);

  final String value;
  final String url;
  final String image;

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);

  Map<String, dynamic> toJson() => _$JokeToJson(this);

}