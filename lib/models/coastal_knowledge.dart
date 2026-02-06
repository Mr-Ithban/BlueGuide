import 'package:hive/hive.dart';

part 'coastal_knowledge.g.dart';

@HiveType(typeId: 0)
class CoastalKnowledge {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String category;

  /// scientifically_verified | community_verified | not_verified
  @HiveField(4)
  String verificationStatus;

  /// Confidence score calculated from reviews & usage (0–100)
  @HiveField(5)
  int confidenceScore;

  /// Incremented every time this knowledge is accessed
  @HiveField(6)
  int accessCount;

  @HiveField(7)
  String contributorId;

  @HiveField(8)
  DateTime createdAt;

  CoastalKnowledge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.verificationStatus,
    required this.confidenceScore,
    required this.accessCount,
    required this.contributorId,
    required this.createdAt,
  });
}
