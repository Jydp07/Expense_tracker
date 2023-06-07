import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class UserExpenseNotifier extends StateNotifier<List<Expense>> {
  UserExpenseNotifier() : super(const []);

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'expense.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_expense(id TEXT PRIMARY KEY,title TEXT,amount REAL,date DATETIME,category TEXT)');
    }, version: 2);
    return db;
  }

  Future<void> loadData() async {
    final db = await _getDatabase();
    final data = await db.query('user_expense');
    final expense = data
        .map((row) => Expense(
            id: row['id'] as String,
            title: row['title'] as String,
            amount: row['amount'] as double,
            date: row['date'] as String,
            category: Category.values.byName(row['category'].toString())))
        .toList();
    state = expense;
  }

  Future<void> addExpense(
      String title, double amount, String date, Category category) async {
    final newExpense =
        Expense(title: title, amount: amount, date: date, category: category);

    final db = await _getDatabase();
    db.insert('user_expense', {
      'id': newExpense.id,
      'title': newExpense.title,
      'amount': newExpense.amount,
      'date': newExpense.date,
      'category': newExpense.category.name,
    });
    state = [...state,newExpense];
  }

  Future<void> deleteExpense(Expense expense,BuildContext context)async {
    final db = await _getDatabase();
    final expenseIndex = state.indexOf(expense);
    db.delete('user_expense',where: 'id = ?',whereArgs: [expense.id]);
    state.remove(state[expenseIndex]);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Expense Deleted'),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: (){
          state.insert(expenseIndex, expense);
          db.insert('user_expense', {
            'id': expense.id,
            'title': expense.title,
            'amount': expense.amount,
            'date': expense.date,
            'category': expense.category.name,
          });
          state = [...state];
        },
      ),
    ),);
    state = [...state];
  }
}

final userProvider = StateNotifierProvider<UserExpenseNotifier, List<Expense>>(
    (ref) => UserExpenseNotifier());
