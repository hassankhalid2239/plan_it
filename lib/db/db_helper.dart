import 'package:sqflite/sqflite.dart';
import '../Model/task_model.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = "tasks";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    String path = await getDatabasesPath() + 'tasks.db';
    _db = await openDatabase(path, version: _version, onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE $_tableName("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title TEXT,"
        "isCompleted TEXT,"
        "until TEXT,"
        "reminderDays VARCHAR(40),"
        "createdDate TEXT,"
        "dueTime TEXT,"
        "dueDate TEXT)",
      );
    });
  }

  static Future<int> insert(TaskModel? task) async {
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }
  static Future<List<Map<String, dynamic>>> daysTask() async {
    // return await _db!.query(_tableName);
    return await _db!.query(
      _tableName, // Replace with your table name
      where: 'reminderDays != ""',
    );
  }

  // Function to fetch the ID where dueDate matches the user input
  static Future<int?> fetchTaskIdByDueDate(String dueDate) async {
    if (_db == null) {
      await initDB();
    }

    // Use rawQuery to fetch only the ID
    List<Map<String, dynamic>> result = await _db!.rawQuery(
      'SELECT id FROM $_tableName WHERE dueDate = ?',
      [dueDate],
    );

    // If a record is found, return the ID, otherwise return null
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null; // No matching record found
    }
  }

  // Function to fetch tasks where reminderDays is not an empty string
  static Future<List<Map<String, dynamic>>> fetchTasksWithReminderDays() async {
    return await _db!.query(
      _tableName,
      where: 'reminderDays != ?',
      whereArgs: [''],
    );
  }


  //
  // static Future<List<Map<String, dynamic>>> queryByTime() async {
  //   return await _db!.query(_tableName, orderBy: 'date');
  // }
  //
  // static Future<int> getCompletedTaskCount() async {
  //   final List<Map<String, dynamic>> result = await _db!.rawQuery(
  //       'SELECT COUNT(*) as count FROM $_tableName WHERE isCompleted = ?',
  //       ['true']);
  //   return Sqflite.firstIntValue(result) ?? 0;
  // }

  static delete(TaskModel task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }



  static update(int id, String isCompleted) async {
    await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id =?
      ''', [isCompleted, id]);
  }

  static updateTask(TaskModel task) async {
    await _db!.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
