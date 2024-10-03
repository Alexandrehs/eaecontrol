import 'package:eaecontrol/configs/app_colors.dart';
import 'package:eaecontrol/configs/formatters.dart';
import 'package:eaecontrol/data/sqlite_repository.dart';
import 'package:eaecontrol/data/tags_data.dart';
import 'package:eaecontrol/models/control_model.dart';
import 'package:eaecontrol/states/control_states.dart';
import 'package:eaecontrol/stories/control_storie.dart';
import 'package:eaecontrol/views/add_entry_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _controlStorie = ControlStorie(
    repository: SQLiteRepository(),
  );

  @override
  void initState() {
    _controlStorie.getControl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _controlStorie,
        builder: (context, state, _) {
          if (state is ControlLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ControlErrorState) {
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
                      onPressed: () => _controlStorie.getControl(),
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

          if (state is ControlSuccessState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                    width: double.infinity,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, top: 16.0),
                              child: Text(
                                Formatters.formatterCurrentMonth(DateTime.now())
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                    color: AppColors.PAINEL_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "R\$ ${Formatters.formatterCurrency(state.control.total)}",
                            style: const TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: AppColors.PAINEL_TEXT_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: state.control.entrys.length,
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Divider(),
                    ),
                    itemBuilder: (context, index) {
                      Entry entry = state.control.entrys[index];
                      Tag tag = TagsData.getTag(entry.tagid);

                      return ListTile(
                        onLongPress: () => _showModalDeleteEntry(entry.id),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: tag.color,
                              ),
                              child: Text(
                                tag.name,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              entry.creation,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          entry.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: entry.type == EntryType.entry.name
                            ? Text(
                                "R\$ +${Formatters.formatterCurrency(entry.value)}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.SUCCESS_COLOR),
                              )
                            : Text(
                                "R\$ ${Formatters.formatterCurrency(entry.value)}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.ERROR_CANCEL_COLOR),
                              ),
                      );
                    },
                  )
                ],
              ),
            );
          }

          return const Center(
            child: Text("Ainda não há entradas ou saídas"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.PRIMARY_COLOR,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEntryView(),
            ),
          ).then((entry) {
            if (entry != null) {
              entry as Entry;
              if (entry.description.isNotEmpty) {
                _controlStorie.insertEntry(entry);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text("adicionado com sucesso!"),
                  ),
                );
              }
            }
          });
        },
        child: const Icon(
          Icons.add,
          size: 35,
          color: AppColors.PAINEL_TEXT_COLOR,
        ),
      ),
    );
  }

  _deleteEntry(int id) {
    _controlStorie.deleteEntry(id);
  }

  _showModalDeleteEntry(id) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Tem certeza que deseja deletar?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: AppColors.ERROR_CANCEL_COLOR,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _deleteEntry(id);
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("item deletado com sucesso"),
                          ),
                        );
                      },
                      child: const Text("Confirmar"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
