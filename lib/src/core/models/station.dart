import 'package:freezed_annotation/freezed_annotation.dart';

part 'station.freezed.dart';
part 'station.g.dart';

/// Represents a radio station from Radio Browser API
@freezed
abstract class Station with _$Station {
  const factory Station({
    /// Unique station identifier (UUID)
    @JsonKey(name: 'stationuuid') required String stationUuid,

    /// Station name
    required String name,

    /// Stream URL (main)
    required String url,

    /// Resolved stream URL (fallback if url fails)
    @JsonKey(name: 'url_resolved') String? urlResolved,

    /// Station homepage/website
    String? homepage,

    /// Favicon/logo URL
    required String favicon,

    /// Country name
    required String country,

    /// Country code (ISO 3166-1 alpha-2)
    @JsonKey(name: 'countrycode') required String countryCode,

    /// Language (comma-separated if multiple)
    String? language,

    /// Tags (comma-separated)
    String? tags,

    /// Current votes (popularity)
    required int votes,

    /// Codec (MP3, AAC, etc.)
    required String codec,

    /// Bitrate in kbps
    required int bitrate,

    /// Last check status
    @JsonKey(name: 'lastcheckok') int? lastCheckOk,

    /// Latitude for geolocation
    @JsonKey(name: 'geo_lat') double? geoLat,

    /// Longitude for geolocation
    @JsonKey(name: 'geo_long') double? geoLong,
  }) = _Station;

  /// From JSON factory
  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
}
