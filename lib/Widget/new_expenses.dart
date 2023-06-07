import 'dart:io';

import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/provider/user_expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewExpenses extends ConsumerStatefulWidget {
  const NewExpenses({super.key});

  @override
  ConsumerState<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends ConsumerState<NewExpenses> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedDate;
  Category _selectedCategory = Category.leisure;
  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }
  Expense? expense;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate.toString();
    });
  }

  void _showDialog(){
    if(Platform.isAndroid){
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Invalid Input'),
        content: const Text(
            'Please make sure a valid title,amount,date and category was entered'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Close'))
        ],
      ));
    }
    else{
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text(
                'Please make sure a valid title,amount,date and category was entered'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text('Close'))
            ],
          ));
    }
  }



  @override
  Widget build(BuildContext context) {
    void submitExpenseData() {
      final enteredTitle = _titleController.text;
      final enteredAmount = double.tryParse(_amountController.text);
      final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
      if (_titleController.text.trim().isEmpty ||
          amountIsInvalid ||
          _selectedDate == null) {
        _showDialog();
        return;
      }
      ref.watch(userProvider.notifier).addExpense(enteredTitle,enteredAmount,_selectedDate!, _selectedCategory);
      Navigator.pop(context);
    }
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final heightFromBottom = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraint) {
      final width = constraint.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 48, 16, heightFromBottom + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '₹',
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _selectedCategory,
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(
                            () {
                              _selectedCategory = value;
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      _selectedDate == null
                          ? const Text('Select Date')
                          : Text(formatter.format(DateTime.parse(_selectedDate!))),
                      IconButton(
                        onPressed: _presentDatePicker,
                        icon: Icon(
                          Icons.calendar_month,
                          color: isDark
                              ? kColorSchemeDark.onSecondary
                              : kColorScheme.onSecondary,
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                            prefixText: '₹',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _selectedDate == null
                                ? const Text('Select Date')
                                : Text(formatter.format(DateTime.parse(_selectedDate!))),
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: Icon(
                                Icons.calendar_month,
                                color: isDark
                                    ? kColorSchemeDark.onSecondary
                                    : kColorScheme.onSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (width >= 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 26,
                      ),
                      ElevatedButton(
                        onPressed: submitExpenseData,
                        child: const Text('Save Expense'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      )
                    ],
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: submitExpenseData,
                          child: const Text('Save Expense'),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'))
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      );
    });
  }
}
