import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/src.dart';

part 'languages_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Facet>> languages(Ref ref) async {
  final api = ref.watch(radioBrowserApiProvider);
  final result = await api.getLanguages();

  return result.when(
    success: (languages) {
      final sorted = List<Facet>.from(languages)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return sorted;
    },
    failure: (error) => throw Exception(error),
  );
}
