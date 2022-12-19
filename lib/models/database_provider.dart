import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../contants/icons.dart';

class DatabaseProvider {
  Database? _database;

  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();

    const dbName = 'expense_tc.db';
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
    return _database!;
  }

  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';

  Future<void> _createDb(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute(
          '''CREATE TABLE $cTable(title TEXT, entries INTEGER, totalAmount TEXT)''');

      await txn.execute('''CREATE TABLE $eTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          amount TEXT,
          date TEXT,
          category TEXT)''');

      for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString(),
        });
      }
    });
  }
}
