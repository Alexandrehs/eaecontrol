import 'package:eaecontrol/models/resume_model.dart';

abstract class ResumeBaseState {}

class ResumeInitState extends ResumeBaseState {}

class ResumeLoadingState extends ResumeBaseState {}

class ResumeSuccessState extends ResumeBaseState {
  final List<ResumeModel> resumes;

  ResumeSuccessState({required this.resumes});
}

class ResumeErrorState extends ResumeBaseState {
  final String message;

  ResumeErrorState({required this.message});
}
