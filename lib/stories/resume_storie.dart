import 'package:eaecontrol/data/control_repository.dart';
import 'package:eaecontrol/states/resumet_states.dart';
import 'package:flutter/material.dart';

class ResumeStorie extends ValueNotifier<ResumeBaseState> {
  ResumeStorie({required this.repository}) : super(ResumeInitState());

  final ControlRepository repository;

  Future getResumes() async {
    value = ResumeLoadingState();

    try {
      final response = await repository.getResume(3);

      if (response.isEmpty || response == null) {
        value = ResumeInitState();
      } else {
        value = ResumeSuccessState(resumes: response);
      }
    } catch (e) {
      value = ResumeErrorState(message: e.toString());
    }
  }

  Future cleanTable() async {
    try {
      await repository.cleanEntrys();
    } catch (e) {
      value = ResumeErrorState(message: e.toString());
    }
  }

  Future dropTable(String table) async {
    try {
      await repository.dropTable(table);
    } catch (e) {
      value = ResumeErrorState(message: e.toString());
    }
  }
}
