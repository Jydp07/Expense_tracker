import 'package:expense_tracker/Widget/Expense_List/expenselistitem.dart';
import 'package:expense_tracker/provider/user_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/expense.dart';

class ExpensesList extends ConsumerStatefulWidget {
  const ExpensesList({required this.expenses, super.key});

  final List<Expense> expenses;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpenseListState();
}

class _ExpenseListState extends ConsumerState<ExpensesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.expenses.length,
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(
              Icons.delete,
              size: 49,
            ),
          ),
        ),
        key: ValueKey(widget.expenses[index]),
        onDismissed: (direction) {
          ref.watch(userProvider.notifier).deleteExpense(widget.expenses[index],context);
        },
        child: ExpenseItem(
          expense: widget.expenses[index],
        ),
      ),
    );
  }
}
