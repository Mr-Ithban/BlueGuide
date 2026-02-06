import 'package:hive_flutter/hive_flutter.dart';
import '../models/coastal_knowledge.dart';

class HiveService {
  static const String knowledgeBox = 'knowledge_box';

  static Box<CoastalKnowledge> get box =>
      Hive.box<CoastalKnowledge>(knowledgeBox);

  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CoastalKnowledgeAdapter());
    await Hive.openBox<CoastalKnowledge>(knowledgeBox);
  }

  /// HYBRID FREQUENCY + LRU LOGIC
  ///
  /// - accessCount tracks popularity
  /// - createdAt used for recency
  /// - When storage limit reached:
  ///   remove least accessed & oldest data first
  static void cacheKnowledge(CoastalKnowledge knowledge) {
    final box = Hive.box<CoastalKnowledge>(knowledgeBox);

    box.put(knowledge.id, knowledge);

    if (box.length > 100) {
      final sorted = box.values.toList()
        ..sort((a, b) {
          final scoreA = a.accessCount + a.createdAt.millisecondsSinceEpoch;
          final scoreB = b.accessCount + b.createdAt.millisecondsSinceEpoch;
          return scoreA.compareTo(scoreB);
        });

      box.delete(sorted.first.id);
    }
  }
}
