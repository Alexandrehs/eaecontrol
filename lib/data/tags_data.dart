import 'package:flutter/material.dart';

import '../models/control_model.dart';

class TagsData {
  static final List<Tag> list = [
    Tag(1, "supermecado", Colors.blue, TagType.exit.name),
    Tag(2, "sacolao", Colors.green, TagType.exit.name),
    Tag(3, "farmacia", Colors.redAccent, TagType.exit.name),
    Tag(4, "carro", Colors.grey, TagType.exit.name),
    Tag(5, "casa", Colors.yellow, TagType.exit.name),
    Tag(6, "academia", Colors.orange, TagType.exit.name),
    Tag(7, "outros", Colors.black, TagType.exit.name),
    Tag(8, "salario", Colors.lightGreen, TagType.entry.name),
  ];

  static getTag(int id) {
    return list.firstWhere((tag) => tag.id == id);
  }
}
