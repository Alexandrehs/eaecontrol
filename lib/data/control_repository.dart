import 'package:eaecontrol/models/control_model.dart';
import 'package:eaecontrol/models/resume_model.dart';

abstract class ControlRepository {
  Future<List<Entry>> getAllEntrys(DateTime period);
  Future<void> insertEntry({required Entry entry});
  Future<void> deleteEntry(int id);
  Future<List<ResumeModel>> getResume(int quantity);
  Future<void> cleanEntrys();
  Future<void> dropTable(String table);
}
