import 'package:expense_tracker/Widget/expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

var kColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 96, 59, 181),
    brightness: Brightness.dark);
var kColorSchemeDark =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 199, 125));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: true,
          colorScheme: kColorScheme,
          cardTheme: const CardTheme().copyWith(
              color: kColorSchemeDark.onSecondaryContainer,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorSchemeDark.onPrimaryContainer,
                foregroundColor: kColorSchemeDark.onPrimary),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: kColorSchemeDark.onSecondary,
          )),
      theme: ThemeData().copyWith(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: kColorScheme,
        cardTheme: const CardTheme().copyWith(
            color: kColorScheme.onSecondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.onPrimaryContainer,
              foregroundColor: kColorScheme.onSecondary),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: kColorScheme.onSecondary,
        ),
        iconTheme: IconThemeData(color: kColorScheme.onSecondary),
        textButtonTheme: TextButtonThemeData(
          style: const ButtonStyle().copyWith(
            //backgroundColor: MaterialStatePropertyAll(kColorScheme.onPrimaryContainer),
            foregroundColor: MaterialStatePropertyAll(kColorScheme.onSecondary),
          ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: kColorSchemeDark.onSecondaryContainer,
        )
      ),
      themeMode: ThemeMode.system,
      home: const Expenses(),
    );
  }
}
