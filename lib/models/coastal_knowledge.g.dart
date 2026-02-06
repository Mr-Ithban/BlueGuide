// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coastal_knowledge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoastalKnowledgeAdapter extends TypeAdapter<CoastalKnowledge> {
  @override
  final int typeId = 0;

  @override
  CoastalKnowledge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoastalKnowledge(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      verificationStatus: fields[4] as String,
      confidenceScore: fields[5] as int,
      accessCount: fields[6] as int,
      contributorId: fields[7] as String,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CoastalKnowledge obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.verificationStatus)
      ..writeByte(5)
      ..write(obj.confidenceScore)
      ..writeByte(6)
      ..write(obj.accessCount)
      ..writeByte(7)
      ..write(obj.contributorId)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoastalKnowledgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
