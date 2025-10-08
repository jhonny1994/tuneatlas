import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuneatlas/src/core/core.dart';

part 'tags_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Facet>> tags(Ref ref) async {
  final api = ref.watch(radioBrowserApiProvider);
  final result = await api.getTags();

  return result.when(
    success: (tags) {
      final sorted = List<Facet>.from(tags)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      return sorted;
    },
    failure: (error) => throw Exception(error),
  );
}
