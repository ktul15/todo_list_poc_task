import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_poc_task/feature/add_todo/presentation/bloc/add_todo_bloc.dart';

import '../../../../core/utils/input_field_formatters.dart';

class AddTodoView extends StatelessWidget {
  AddTodoView({super.key});

  final TextEditingController dateController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(appLocalizations!.addTodoPage_appBarTitle),
      ),
      body: BlocConsumer<AddTodoBloc, AddTodoState>(
        listener: (context, state) {
          print("here");
          if (state.newlyAddedTodo != null) {
            context.pop(state.newlyAddedTodo);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: context.read<AddTodoBloc>().state.text,
                          inputFormatters: [
                            NoLeadingSpaceFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText:
                                appLocalizations.addTodoPage_textfield_hint,
                          ),
                          onChanged: (value) {
                            context
                                .read<AddTodoBloc>()
                                .add(AddTodoTextChanged(text: value));
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return appLocalizations
                                  .addTodoPage_textfield_empty_null_error;
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          readOnly: true,
                          controller: dateController,
                          decoration: InputDecoration(
                            hintText:
                                appLocalizations.addTodoPage_dueDatefield_hint,
                            suffixIcon: const Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(
                                  days: 365,
                                ),
                              ),
                            );

                            if (pickedDate != null) {
                              print("pickedDate: ${pickedDate}");
                              dateController.text =
                                  DateFormat("MMM dd, yyy").format(pickedDate);
                              context.read<AddTodoBloc>().add(
                                    AddTodoDateChanged(
                                      date: pickedDate,
                                    ),
                                  );
                            }
                          },
                          validator: (value) {
                            if (context.read<AddTodoBloc>().state.dueDate ==
                                null) {
                              return appLocalizations
                                  .addTodoPage_dueDatefield_empty_null_error;
                            } else {
                              return null;
                            }
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        DropdownMenu<TodoPriority>(
                          width: MediaQuery.of(context).size.width - 48,
                          label:
                              Text(appLocalizations.addTodoPage_dropdown_label),
                          dropdownMenuEntries: TodoPriority.values.map((value) {
                            print("val: $value");
                            return DropdownMenuEntry<TodoPriority>(
                              value: value,
                              label: value.text,
                            );
                          }).toList(),
                          onSelected: (value) {
                            if (value != null) {
                              context.read<AddTodoBloc>().add(
                                    AddTodoPriorityChanged(
                                      todoPriority: value,
                                    ),
                                  );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() == true) {
                              // submit form
                              final state = context.read<AddTodoBloc>().state;
                              context.read<AddTodoBloc>().add(
                                    const AddTodoFormSubmitted(),
                                  );
                            }
                          },
                          child: Text(
                              appLocalizations.addTodoPage_add_button_label),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
