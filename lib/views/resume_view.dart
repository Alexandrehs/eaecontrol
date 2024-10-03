import 'package:eaecontrol/configs/app_colors.dart';
import 'package:eaecontrol/configs/formatters.dart';
import 'package:eaecontrol/data/sqlite_repository.dart';
import 'package:eaecontrol/models/control_model.dart';
import 'package:eaecontrol/states/resumet_states.dart';
import 'package:eaecontrol/stories/resume_storie.dart';
import 'package:flutter/material.dart';

class ResumeView extends StatefulWidget {
  const ResumeView({super.key});

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  final _resumeStorie = ResumeStorie(repository: SQLiteRepository());

  @override
  void initState() {
    _resumeStorie.getResumes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _resumeStorie,
        builder: (context, state, child) {
          if (state is ResumeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ResumeErrorState) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.ERROR_CANCEL_COLOR,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.PAINEL_TEXT_COLOR,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () => _resumeStorie.getResumes(),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Tentar novamente"),
                          Icon(
                            Icons.refresh,
                          )
                        ],
                      ))
                ],
              ),
            );
          }

          if (state is ResumeSuccessState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Resumo geral da somatória dos meses",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.resumes.length,
                      separatorBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Divider(),
                      ),
                      itemBuilder: (context, index) {
                        return ListTile(
                          subtitle: Text(
                            Formatters.formatterCurrentMonthByInt(
                              int.parse(state.resumes[index].month),
                            ),
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          trailing: Text(
                            "R\$ ${Formatters.formatterCurrency(state.resumes[index].result)}",
                            style: const TextStyle(
                              color: AppColors.PRIMARY_COLOR,
                              fontSize: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text("Ainda não há entradas ou saídas"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _resumeStorie.cleanTable(),
      ),
    );
  }
}
