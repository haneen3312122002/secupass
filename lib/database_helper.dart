import 'package:secupass/features/home_screen/data/models/account_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  //single obj to ensure no other obj:
  //نسخة وحدة داخل التطبيق دون تكرار
  static final DataBaseHelper instance = DataBaseHelper._internal();
  //internal:internal constructor to ensure no creation for the obj from outside the class, only from the class i can make an obj
  static Database? _database;
  //factory: constructor for return the same instance every time instead of creating no one:
  factory DataBaseHelper() => instance;
  //create one instance and store it in line: 7:
  DataBaseHelper._internal();
  //access the database and get it / open it:
  Future<Database> get database async {
    //if _database is null: create it
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'accounts_db.db');
    //create db:
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //create table:
  // create table:
  Future _onCreate(Database db, int version) async {
    // Create the 'accounts' table
    await db.execute('''
  CREATE TABLE accounts(
   id INTEGER PRIMARY KEY, 
   appName TEXT NOT NULL,
   encPass TEXT NOT NULL,
   userName TEXT,
   photoPath TEXT,
   selectedDays INTEGER,
   lastUpdate TEXT,
   nextUpdate TEXT
  )
 '''); // <-- Note the closing triple quotes and semicolon here

    // Create the 'nots' table separately
    await db.execute('''
  CREATE TABLE nots(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   title TEXT NOT NULL,
   body TEXT NOT NULL,
   date TEXT NOT NULL
  )
 ''');
    await db.execute('''
  CREATE TABLE pin(
   id INTEGER PRIMARY KEY AUTOINCREMENT,
   pin INTEGER NOT NULL
  )
 ''');
  }

  @override
  Future<AccountModel?> getAccountDetails(int? id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AccountModel.fromMap(maps.first);
    } else {
      return null; // Return null if no account with the given ID is found
    }
  }

  //insert
  Future<void> insertAccount(Map<String, dynamic> account) async {
    final db = await database; // تأكد أن اسمها database مش Database
    await db.insert('accounts', account);
  }

  // return value
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await database;
    return await db.query('accounts', orderBy: 'id DESC');
  }

  Future<void> updateAccount(int? id, Map<String, dynamic> account) async {
    final db = await database;
    await db.update('accounts', account, where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteAccount(int id) async {
    final db = await database;
    await db.delete('accounts', where: 'id=?', whereArgs: [id]);
  }

  //..........................
  Future<void> insertNot(Map<String, dynamic> not) async {
    final db = await database; // تأكد أن اسمها database مش Database
    await db.insert('nots', not);
  }

  // return value
  Future<List<Map<String, dynamic>>> getNots() async {
    final db = await database;
    return await db.query('nots', orderBy: 'id DESC');
  }

  Future<void> updateNot(int? id, Map<String, dynamic> not) async {
    final db = await database;
    await db.update('nots', not, where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteNot(int id) async {
    final db = await database;
    await db.delete('nots', where: 'id=?', whereArgs: [id]);
  }

//............................................
  Future<void> insertPin(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('pin', data); // SQLite سيُنشئ الـ ID تلقائيًا
  }

  Future<void> updatePin(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update(
      'pin',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //............................................
  Future<bool> verifyPin(int pin) async {
    final db = await database;
    final result = await db.query(
      'pin', // أو أي جدول خزنت فيه الـ PIN
      where: 'pin = ?',
      whereArgs: [pin],
    );
    return result.isNotEmpty;
  }
  // في ملف database_helper.dart
// ...

  Future<bool> isPinSet() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.query('pin', columns: ['COUNT(*)']));
    return count != null && count > 0;
  }

// ...
}
