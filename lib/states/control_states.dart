import 'package:eaecontrol/models/control_model.dart';

abstract class ControlBaseState {}

class ControlInitState extends ControlBaseState {}

class ControlLoadingState extends ControlBaseState {}

class ControlSuccessState extends ControlBaseState {
  final ControlModel control;

  ControlSuccessState({required this.control});
}

class ControlErrorState extends ControlBaseState {
  final String message;

  ControlErrorState({required this.message});
}
