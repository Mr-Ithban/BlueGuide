import '../models/coastal_knowledge.dart';
import 'hive_service.dart';

class OfflineAIService {
  static CoastalKnowledge? getResponse(String query) {
    // final box = HiveService.box; // redundant assignment if not used?

    final items = HiveService.box.values
        .where(
          (k) =>
              k.title.toLowerCase().contains(query.toLowerCase()) ||
              k.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (items.isEmpty) return null;

    items.sort((a, b) => b.accessCount.compareTo(a.accessCount));

    items.first.accessCount++;
    HiveService.cacheKnowledge(items.first);

    return items.first;
  }
}
