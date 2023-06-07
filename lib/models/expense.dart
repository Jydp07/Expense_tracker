import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uid = Uuid();

enum Category {
  food,
  travel,
  leisure,
  work,
}

final formatter = DateFormat.yMd();

const categoryIcon = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie_creation_outlined,
  Category.work: Icons.work
};

class Expense {
  Expense(
      {
        id,required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = id ?? uid.v4();

  final String id;
  final String title;
  final double amount;
  final String date;
  final Category category;

  String get formattedDate {
    return formatter.format(DateTime.parse(date));
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((expense) => expense.category == category)
            .toList();
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
