import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS users');
      await db.execute('DROP TABLE IF EXISTS favorite_workouts');
      await _createDB(db, newVersion);
    }

    if (oldVersion < 3) {
      // Geçici tablo oluştur
      await db.execute('''
        CREATE TABLE users_temp (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL,
          phone TEXT,
          age INTEGER,
          height REAL,
          weight REAL,
          goal TEXT,
          profileImage TEXT
        )
      ''');

      // Eski veriler yeni tabloya kopyalanıyor
      await db.execute('''
        INSERT INTO users_temp (id, name, email, phone, age, height, weight, goal)
        SELECT id, name, email, phone, age, height, weight, goal FROM users
      ''');

      // Eski tablo siliniyor
      await db.execute('DROP TABLE users');

      // Geçici tablo yeniden adlandırılıyor
      await db.execute('ALTER TABLE users_temp RENAME TO users');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL';

    await db.execute('''
CREATE TABLE users (
  id $idType,
  name $textType,
  email $textType,
  phone TEXT,
  age INTEGER,
  height $realType,
  weight $realType,
  goal TEXT,
  profileImage TEXT
)
''');

    await db.execute('''
CREATE TABLE favorite_workouts (
  id $idType,
  userId $integerType,
  workoutName $textType,
  FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
)
''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        workoutName TEXT,
        duration INTEGER,
        date TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Varsayılan kullanıcı oluştur
    await db.insert('users', {
      'name': '',
      'email': '',
      'phone': '',
      'age': null,
      'height': null,
      'weight': null,
      'goal': '',
      'profileImage': null
    });
  }

  // Kullanıcı işlemleri
  Future<Map<String, dynamic>?> getUser(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> data) async {
    final db = await instance.database;
    return db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Favori antrenmanlar
  Future<List<Map<String, dynamic>>> getFavoriteWorkouts(int userId) async {
    final db = await instance.database;
    return db.query(
      'favorite_workouts',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future<bool> isWorkoutFavorite(int userId, String workoutName) async {
    final db = await instance.database;
    final result = await db.query(
      'favorite_workouts',
      where: 'userId = ? AND workoutName = ?',
      whereArgs: [userId, workoutName],
    );
    return result.isNotEmpty;
  }

  Future<void> addFavoriteWorkout(int userId, String workoutName) async {
    final db = await instance.database;
    await db.insert(
      'favorite_workouts',
      {
        'userId': userId,
        'workoutName': workoutName,
      },
    );
  }

  Future<void> removeFavoriteWorkout(int userId, String workoutName) async {
    final db = await instance.database;
    await db.delete(
      'favorite_workouts',
      where: 'userId = ? AND workoutName = ?',
      whereArgs: [userId, workoutName],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_app.db');
    await deleteDatabase(path);
    _database = null;
  }

  Future<List<Map<String, dynamic>>> getWorkoutHistory(int userId) async {
    final db = await database;
    return await db.query(
      'workout_history',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }
}
