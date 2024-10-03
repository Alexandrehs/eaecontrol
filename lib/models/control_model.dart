import 'package:flutter/material.dart';

class ControlModel {
  final double total;
  final List<Entry> entrys;

  ControlModel({required this.total, required this.entrys});

  factory ControlModel.empty() {
    return ControlModel(total: 0, entrys: []);
  }

  factory ControlModel.copyWith(
      {required double total, required List<Entry> entrys}) {
    return ControlModel(total: total ?? total, entrys: entrys ?? entrys);
  }

  double getTotal() {
    double a = total;
    entrys.map((e) => a += e.value);
    return a;
  }
}

class Entry {
  final int id;
  final String description;
  final double value;
  final String creation;
  final int tagid;
  final String month;
  final String type;

  Entry(this.id, this.description, this.value, this.creation, this.tagid,
      this.month, this.type);

  factory Entry.empty() {
    return Entry(0, "", 0, "${DateTime.now()}", 0, "", "");
  }

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "description": description,
      "value": value,
      "creation": creation,
      "tagid": tagid,
      "month": month,
      "type": type,
    };
  }
}

class Tag {
  final int id;
  final String name;
  final Color color;
  final String type;

  Tag(this.id, this.name, this.color, this.type);
}

enum TagType { entry, exit }

enum EntryType { entry, exit }
