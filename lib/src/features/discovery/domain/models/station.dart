import 'package:freezed_annotation/freezed_annotation.dart';

part 'station.freezed.dart';
part 'station.g.dart';

@freezed
abstract class Station with _$Station {
  const factory Station({
    @JsonKey(name: 'stationuuid') required String stationUuid,
    required String name,
    required String url,
    @JsonKey(name: 'url_resolved') required String urlResolved,
    @JsonKey(name: 'countrycode') required String countryCode,
    String? state,
    String? favicon,
    String? tags,
    @Default(0) int votes,
  }) = _Station;
  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
}
