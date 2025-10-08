import 'package:freezed_annotation/freezed_annotation.dart';

part 'facet.freezed.dart';
part 'facet.g.dart';

/// Represents a facet (category) from Radio Browser API
/// Used for countries, languages, tags, etc.
@freezed
abstract class Facet with _$Facet {
  const factory Facet({
    required String name,
    @JsonKey(name: 'stationcount') required int stationCount,
    @JsonKey(name: 'iso_3166_1') String? code,
  }) = _Facet;

  /// From JSON factory
  factory Facet.fromJson(Map<String, dynamic> json) => _$FacetFromJson(json);
}
