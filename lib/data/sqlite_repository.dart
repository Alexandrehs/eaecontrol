import 'package:eaecontrol/configs/formatters.dart';
import 'package:eaecontrol/data/control_repository.dart';
import 'package:eaecontrol/models/control_model.dart';
import 'package:eaecontrol/models/resume_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteRepository implements ControlRepository {
  Future<Database> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    return openDatabase(
      join(await getDatabasesPath(), 'eaecontrol.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE IF NOT EXISTS entrys(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            description TEXT,
            value REAL,
            creation TEXT,
            tagid INTEGER,
            month TEXT,
            type TEXT
          );
        ''');
      },
      version: 1,
    );
  }

  @override
  Future<void> deleteEntry(int id) async {
    try {
      final db = await init();

      await db.delete("entrys", where: "id = $id");
    } catch (e) {
      throw Exception(
        "Problemas ao deletar entrada id: $id, erro:${e.toString()}",
      );
    }
  }

  @override
  Future<List<Entry>> getAllEntrys(DateTime period) async {
    try {
      final db = await init();

      final List<Map<String, Object?>> response = await db.query(
        "entrys",
        //where: "creation >= date($dateInit) OR creation <= date($dateFinal)",
        where: "month = ${period.month}",
        //where: "creation >= $dateFinal",
        orderBy: "creation asc",
      );

      return [
        for (final {
              "id": id as int,
              "description": description as String,
              "value": value as double,
              "creation": creation as String,
              "tagid": tagid as int,
              "month": month as String,
              "type": type as String
            } in response)
          Entry(id, description, value, creation, tagid, month, type)
      ];
    } catch (e) {
      throw Exception(
        "Problemas ao buscar as entradas, erro:${e.toString()}",
      );
    }
  }

  @override
  Future<void> insertEntry({required Entry entry}) async {
    try {
      final db = await init();

      await db.insert(
        "entrys",
        entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception(
        "Problemas ao inserir uma entradas, erro:${e.toString()}",
      );
    }
  }

  @override
  Future<List<ResumeModel>> getResume(int quantity) async {
    try {
      final db = await init();

      final List<Map<String, Object?>> response = await db.rawQuery(
        "SELECT SUM(value) as result, month FROM entrys GROUP BY month",
      );

      if (response[0]['result'] == null) {
        return [];
      }

      return [
        for (final {
              "result": result as double,
              "month": month as String,
            } in response)
          ResumeModel(result: result, month: month)
      ];
    } catch (e) {
      throw Exception(
        "Problemas ao buscar os resumos, erro:${e.toString()}",
      );
    }
  }

  @override
  Future<void> cleanEntrys() async {
    try {
      final db = await init();

      db.rawDelete("DELETE FROM entrys");
    } catch (e) {
      throw Exception(
        "Problemas ao deletar dados da tabela entry, erro:${e.toString()}",
      );
    }
  }

  @override
  Future<void> dropTable(String table) async {
    try {
      final db = await init();

      db.rawQuery("DROP TABLE $table");
    } catch (e) {
      throw Exception(
        "Problemas ao deletar tabela $table, erro:${e.toString()}",
      );
    }
  }
}
