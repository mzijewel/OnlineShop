// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MyDao _myDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MCartItem` (`id` INTEGER, `image` TEXT, `title` TEXT, `description` TEXT, `price` INTEGER, `size` INTEGER, `catQuantity` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MOrder` (`id` INTEGER, `numberOfProduct` INTEGER, `totalPrice` REAL, `orderStatus` TEXT, `orderDate` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MOrderItem` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `parenId` INTEGER, `image` TEXT, `title` TEXT, `description` TEXT, `price` INTEGER, `size` INTEGER, `catQuantity` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MFav` (`id` INTEGER, `image` TEXT, `title` TEXT, `description` TEXT, `price` INTEGER, `size` INTEGER, `catQuantity` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MyDao get myDao {
    return _myDaoInstance ??= _$MyDao(database, changeListener);
  }
}

class _$MyDao extends MyDao {
  _$MyDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _mCartItemInsertionAdapter = InsertionAdapter(
            database,
            'MCartItem',
            (MCartItem item) => <String, dynamic>{
                  'id': item.id,
                  'image': item.image,
                  'title': item.title,
                  'description': item.description,
                  'price': item.price,
                  'size': item.size,
                  'catQuantity': item.catQuantity
                },
            changeListener),
        _mOrderInsertionAdapter = InsertionAdapter(
            database,
            'MOrder',
            (MOrder item) => <String, dynamic>{
                  'id': item.id,
                  'numberOfProduct': item.numberOfProduct,
                  'totalPrice': item.totalPrice,
                  'orderStatus': item.orderStatus,
                  'orderDate': item.orderDate
                },
            changeListener),
        _mOrderItemInsertionAdapter = InsertionAdapter(
            database,
            'MOrderItem',
            (MOrderItem item) => <String, dynamic>{
                  'id': item.id,
                  'parenId': item.parenId,
                  'image': item.image,
                  'title': item.title,
                  'description': item.description,
                  'price': item.price,
                  'size': item.size,
                  'catQuantity': item.catQuantity
                }),
        _mFavInsertionAdapter = InsertionAdapter(
            database,
            'MFav',
            (MFav item) => <String, dynamic>{
                  'id': item.id,
                  'image': item.image,
                  'title': item.title,
                  'description': item.description,
                  'price': item.price,
                  'size': item.size,
                  'catQuantity': item.catQuantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _mCartItemMapper = (Map<String, dynamic> row) => MCartItem(
      image: row['image'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      id: row['id'] as int,
      price: row['price'] as int,
      size: row['size'] as int,
      catQuantity: row['catQuantity'] as int);

  static final _mOrderMapper = (Map<String, dynamic> row) => MOrder(
      id: row['id'] as int,
      numberOfProduct: row['numberOfProduct'] as int,
      totalPrice: row['totalPrice'] as double,
      orderStatus: row['orderStatus'] as String,
      orderDate: row['orderDate'] as String);

  static final _mFavMapper = (Map<String, dynamic> row) => MFav(
      image: row['image'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      id: row['id'] as int,
      price: row['price'] as int,
      size: row['size'] as int,
      catQuantity: row['catQuantity'] as int);

  static final _mOrderItemMapper = (Map<String, dynamic> row) => MOrderItem(
      image: row['image'] as String,
      title: row['title'] as String,
      description: row['description'] as String,
      id: row['id'] as int,
      price: row['price'] as int,
      size: row['size'] as int,
      catQuantity: row['catQuantity'] as int);

  final InsertionAdapter<MCartItem> _mCartItemInsertionAdapter;

  final InsertionAdapter<MOrder> _mOrderInsertionAdapter;

  final InsertionAdapter<MOrderItem> _mOrderItemInsertionAdapter;

  final InsertionAdapter<MFav> _mFavInsertionAdapter;

  @override
  Future<List<MCartItem>> getCartItems() async {
    return _queryAdapter.queryList('SELECT * FROM MCartItem',
        mapper: _mCartItemMapper);
  }

  @override
  Future<List<MOrder>> getOrders() async {
    return _queryAdapter.queryList('SELECT * FROM MOrder',
        mapper: _mOrderMapper);
  }

  @override
  Stream<MOrder> getOrderById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM MOrder WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'MOrder',
        isView: false,
        mapper: _mOrderMapper);
  }

  @override
  Future<List<MCartItem>> getCartItemsID() async {
    return _queryAdapter.queryList('SELECT id FROM MCartItem',
        mapper: _mCartItemMapper);
  }

  @override
  Future<List<MFav>> getFav() async {
    return _queryAdapter.queryList('SELECT * FROM MFav', mapper: _mFavMapper);
  }

  @override
  Stream<MCartItem> getCartById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM MCartItem WHERE id = ?',
        arguments: <dynamic>[id],
        queryableName: 'MCartItem',
        isView: false,
        mapper: _mCartItemMapper);
  }

  @override
  Future<List<MOrderItem>> getOrderItems(int id) async {
    return _queryAdapter.queryList('SELECT * FROM MOrderItem WHERE parenId = ?',
        arguments: <dynamic>[id], mapper: _mOrderItemMapper);
  }

  @override
  Future<MCartItem> deleteCart(int id) async {
    return _queryAdapter.query('DELETE FROM MCartItem WHERE id = ?',
        arguments: <dynamic>[id], mapper: _mCartItemMapper);
  }

  @override
  Future<MCartItem> deleteCartAll() async {
    return _queryAdapter.query('DELETE FROM MCartItem',
        mapper: _mCartItemMapper);
  }

  @override
  Future<MFav> deleteFav(int id) async {
    return _queryAdapter.query('DELETE FROM MFav WHERE id = ?',
        arguments: <dynamic>[id], mapper: _mFavMapper);
  }

  @override
  Future<MFav> deleteAllFav() async {
    return _queryAdapter.query('DELETE FROM MFav', mapper: _mFavMapper);
  }

  @override
  Future<void> insertCart(MCartItem mCartItem) async {
    await _mCartItemInsertionAdapter.insert(
        mCartItem, OnConflictStrategy.replace);
  }

  @override
  Future<int> insertOrder(MOrder mOrder) {
    return _mOrderInsertionAdapter.insertAndReturnId(
        mOrder, OnConflictStrategy.replace);
  }

  @override
  Future<int> saveOrderItem(MOrderItem mOrderItem) {
    return _mOrderItemInsertionAdapter.insertAndReturnId(
        mOrderItem, OnConflictStrategy.replace);
  }

  @override
  Future<int> saveFav(MFav mFav) {
    return _mFavInsertionAdapter.insertAndReturnId(
        mFav, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertOrderItem(List<MOrderItem> mOrderItems) {
    return _mOrderItemInsertionAdapter.insertListAndReturnIds(
        mOrderItems, OnConflictStrategy.replace);
  }
}
