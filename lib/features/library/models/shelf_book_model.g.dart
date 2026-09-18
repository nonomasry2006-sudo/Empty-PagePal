// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shelf_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShelfBookModelAdapter extends TypeAdapter<ShelfBookModel> {
  @override
  final int typeId = 0;

  @override
  ShelfBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShelfBookModel(
      book: fields[0] as BookModel,
      status: fields[1] as ShelfStatus,
      currentPage: fields[2] as int,
      addedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ShelfBookModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.book)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.currentPage)
      ..writeByte(3)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShelfBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShelfStatusAdapter extends TypeAdapter<ShelfStatus> {
  @override
  final int typeId = 1;

  @override
  ShelfStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShelfStatus.wantToRead;
      case 1:
        return ShelfStatus.reading;
      case 2:
        return ShelfStatus.finished;
      default:
        return ShelfStatus.wantToRead;
    }
  }

  @override
  void write(BinaryWriter writer, ShelfStatus obj) {
    switch (obj) {
      case ShelfStatus.wantToRead:
        writer.writeByte(0);
        break;
      case ShelfStatus.reading:
        writer.writeByte(1);
        break;
      case ShelfStatus.finished:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShelfStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
