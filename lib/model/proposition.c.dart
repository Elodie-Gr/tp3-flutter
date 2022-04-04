// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropositionAdapter extends TypeAdapter<Proposition> {
  @override
  final int typeId = 0;

  @override
  Proposition read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Proposition()
      ..entreprise = fields[0] as String
      ..salaireBrut = fields[1] as double
      ..salaireNet = fields[2] as double
      ..statutPropose = fields[3] as String
      ..monSentiment = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, Proposition obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.entreprise)
      ..writeByte(1)
      ..write(obj.salaireBrut)
      ..writeByte(2)
      ..write(obj.salaireNet)
      ..writeByte(3)
      ..write(obj.statutPropose)
      ..writeByte(4)
      ..write(obj.monSentiment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
