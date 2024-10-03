import 'dart:math';

import 'package:eaecontrol/configs/app_colors.dart';
import 'package:eaecontrol/configs/formatters.dart';
import 'package:eaecontrol/data/tags_data.dart';
import 'package:eaecontrol/models/control_model.dart';
import 'package:flutter/material.dart';

class AddEntryView extends StatefulWidget {
  const AddEntryView({super.key});

  @override
  State<AddEntryView> createState() => _AddEntryViewState();
}

class _AddEntryViewState extends State<AddEntryView> {
  final _textControllerDescription = TextEditingController();
  final _textControllerValue = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _tagList = TagsData.list;
  late Tag tagSelected;

  @override
  void initState() {
    tagSelected = _tagList.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Text(
                  "Adicionando uma nova entrada/saida",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: _textControllerDescription,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Preencha este campo primeiro.";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    label: Text("Descreva de forma resumida uma descrição.")),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _textControllerValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Preencha este campo primeiro.";
                  }
                  return null;
                },
                decoration: const InputDecoration(label: Text("Qual o valor.")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Selecione uma tag"),
                      DropdownButton(
                        underline: const SizedBox(),
                        value: tagSelected,
                        items: _tagList.map(
                          (tag) {
                            return DropdownMenuItem(
                              value: tag,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${tag.name} - tipo: ${Formatters.formatterTagForPortugue(tag.type)}"),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (Tag? value) {
                          setState(() {
                            tagSelected = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.ERROR_CANCEL_COLOR,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            Entry.empty(),
                          );
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.PAINEL_TEXT_COLOR,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                            (states) => AppColors.SECONDARY_COLOR,
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(
                              context,
                              Entry(
                                Random().nextInt(
                                  10000,
                                ),
                                _textControllerDescription.text,
                                double.parse(
                                    tagSelected.type == TagType.entry.name
                                        ? _textControllerValue.text
                                        : "-${_textControllerValue.text}"
                                            .replaceAll(",", ".")),
                                "${Formatters.formatterCurrent(
                                  DateTime.now(),
                                )}",
                                tagSelected.id,
                                "${DateTime.now().month}",
                                tagSelected.type,
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Confirmar",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.PAINEL_TEXT_COLOR,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
