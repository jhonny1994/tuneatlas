import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'countries_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Facet>> countries(Ref ref) async {
  final api = ref.watch(radioBrowserApiProvider);
  final result = await api.getCountries();

  return result.when(
    success: (countries) {
      final cleaned = countries
          .where(
        (country) => country.code != null && country.code!.isNotEmpty,
      )
          .map((country) {
        final cleanedName = country.name.startsWith('The ')
            ? country.name.substring(4)
            : country.name;

        return country.copyWith(name: cleanedName);
      }).toList()
        ..sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );

      return cleaned;
    },
    failure: (error) => throw Exception(error),
  );
}
