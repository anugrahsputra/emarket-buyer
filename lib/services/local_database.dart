import 'package:emarket_buyer/models/model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static LocalDatabase? _instance;
  static Database? _database;

  LocalDatabase._internal() {
    _instance = this;
  }

  factory LocalDatabase() => _instance ?? LocalDatabase._internal();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initializeDb();
    return _database;
  }

  static const String _tblCart = 'cart';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      '$path/emarket.db',
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tblCart (
            name TEXT NOT NULL,
            imageUrl TEXT NOT NULL,
            sellerId TEXT NOT NULL,
            productId TEXT NOT NULL,
            price INTEGER NOT NULL,
            storeName TEXT NOT NULL,
            quantity INTEGER NOT NULL
          )
        ''');
      },
      version: 1,
    );
    return db;
  }

  Future<List<CartModel>> getAllProducts() async {
    final db = await database;
    var result = await db!.query(_tblCart);

    return result.map((e) => CartModel.fromMap(e)).toList();
  }

  insertProduct(CartModel cartModel) async {
    final db = await database;
    await db!.insert(
      _tblCart,
      cartModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  update(CartModel cartModel) async {
    final db = await database;
    await db!.update(
      _tblCart,
      cartModel.toMap(),
      where: 'productId = ?',
      whereArgs: [cartModel.productId],
    );
  }

  removeProduct(String productId) async {
    final db = await database;
    await db!.delete(
      _tblCart,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  deleteProduct() async {
    final db = await database;
    await db!.delete(_tblCart);
  }
}
