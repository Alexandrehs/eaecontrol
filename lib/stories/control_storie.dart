import 'package:eaecontrol/data/control_repository.dart';
import 'package:eaecontrol/data/tags_data.dart';
import 'package:eaecontrol/models/control_model.dart';
import 'package:eaecontrol/states/control_states.dart';
import 'package:flutter/material.dart';

class ControlStorie extends ValueNotifier<ControlBaseState> {
  ControlStorie({required this.repository}) : super(ControlInitState());

  ControlRepository repository;
  ControlModel _control = ControlModel.empty();
  List<Entry> entrys = [];
  double newTotal = 0.0;

  Future getControl() async {
    value = ControlLoadingState();

    try {
      final entrysRepo = await repository.getAllEntrys(DateTime.now());

      entrys.addAll(entrysRepo);
      newTotal = _getTotal(entrys);

      _control = ControlModel.copyWith(
        total: newTotal,
        entrys: entrys,
      );

      value = ControlSuccessState(control: _control);

      if (entrysRepo.isEmpty) {
        value = ControlInitState();
      }
    } catch (e) {
      value = ControlErrorState(message: e.toString());
    }
  }

  Future insertEntry(Entry entry) async {
    value = ControlLoadingState();

    try {
      await repository.insertEntry(entry: entry);
      entrys.add(entry);
      newTotal = _getTotal(entrys);
      _control = ControlModel.copyWith(total: newTotal, entrys: entrys);
      value = ControlSuccessState(control: _control);
    } catch (e) {
      value = ControlErrorState(message: e.toString());
    }
  }

  Future deleteEntry(int id) async {
    value = ControlLoadingState();

    try {
      await repository.deleteEntry(id);

      _control.entrys.removeWhere((entry) => entry.id == id);
      newTotal = _getTotal(_control.entrys);

      if (_control.entrys.isEmpty) {
        value = ControlInitState();
      } else {
        value = ControlSuccessState(
          control:
              ControlModel.copyWith(total: newTotal, entrys: _control.entrys),
        );
      }
    } catch (e) {
      value = ControlErrorState(message: e.toString());
    }
  }

  _getTotal(List<Entry> entryList) {
    double total = 0.0;
    for (final e in entrys) {
      total = total + e.value;
    }

    return total;
  }

  _getTagType(int id) {
    return TagsData.list.firstWhere((element) => element.id == id);
  }
}
