import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    
    final path = join(await getDatabasesPath(), 'users.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT,
            name TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  static Future<int> registerUser(String email, String password, String name) async {
    final db = await database;
    try {
      return await db.insert('users', {
        'email': email,
        'password': password,
        'name': name,
      });
    } catch (e) {
      return -1;
    }
  }

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    final users = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }
}
