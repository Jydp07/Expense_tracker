import 'package:expense_tracker/Widget/Expense_List/expenseslist.dart';
import 'package:expense_tracker/Widget/chart/chart.dart';
import 'package:expense_tracker/Widget/new_expenses.dart';
import 'package:expense_tracker/provider/user_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class Expenses extends ConsumerStatefulWidget {
  const Expenses({super.key});

  @override
  ConsumerState<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends ConsumerState<Expenses> {

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const NewExpenses(),
    );
  }

  late Future<void> _expenseFuture;
  @override
  void initState() {
    super.initState();
    _expenseFuture = ref.read(userProvider.notifier).loadData();
  }

  @override
  Widget build(context) {
    final registerExpenses = ref.watch(userProvider);
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _openAddExpensesOverlay,
            icon: const Icon(
              Icons.add,
              //color: Colors.black,
              size: 28,
            ),
          ),
        ],
        title: const Text('Expense Tracker'),
      ),
      body: width < 600
          ? Column(
        children: [
          Chart(expenses: registerExpenses),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: FutureBuilder(future: _expenseFuture,
            builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting ? const Center(
                child: CircularProgressIndicator()) : ExpensesList(
              expenses: registerExpenses,
            ),),),
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Chart(expenses: registerExpenses),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: FutureBuilder(future: _expenseFuture,
            builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting ? const Center(
                child: CircularProgressIndicator()) : ExpensesList(
              expenses: registerExpenses,
            ),),),
        ],
      ),
    );
  }
}
