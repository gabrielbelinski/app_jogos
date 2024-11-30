import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String idColumn = "idColumn";
String nameColumn = "nameColumn";
String publisherColumn = "publisherColumn";
String genreColumn = "genreColumn";
String ratingColumn = "ratingColumn";
String gameTable = "gameTable";

class GameHelper {
  static final GameHelper _instance = GameHelper.internal();
  factory GameHelper() => _instance;
  GameHelper.internal();

  late Database _database;

  Future<Database> get database async {
    // Inicializa _database se ainda não foi feito
    return _database ??= await initDb();
  }

  Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "gamesdb.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database database, int newVersion) async {
      await database.execute(
          "CREATE TABLE $gameTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $publisherColumn TEXT, $genreColumn TEXT, $ratingColumn TEXT)");
    });
  }

  Future<Game> saveGame(Game game) async {
    Database dbGame = await database;
    try {
      game.id = await dbGame.insert(gameTable, game.toMap());
    } catch (e) {
      print("Erro ao salvar o jogo: $e");
    }
    return game;
  }

  Future<Game?> getGame(int id) async {
    Database dbGame = await database;
    List<Map<String, dynamic>> maps = await dbGame.query(gameTable,
        columns: [
          idColumn,
          nameColumn,
          publisherColumn,
          genreColumn,
          ratingColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Game.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Game>> getAllGames() async {
    Database dbGame = await database;
    List<Map<String, dynamic>> listMap =
        await dbGame.rawQuery("SELECT * FROM $gameTable");
    List<Game> listGame = listMap.map((map) => Game.fromMap(map)).toList();
    return listGame;
  }

  Future<int> deleteGame(int id) async {
    Database dbGame = await database;
    return await dbGame
        .delete(gameTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateGame(Game game) async {
    Database dbGame = await database;
    return await dbGame.update(gameTable, game.toMap(),
        where: "$idColumn = ?", whereArgs: [game.id]);
  }
}

class Game {
  int? id;
  String? name;
  String? publisher;
  String? genre;
  String? rating;

  Game();

  Game.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    name = map[nameColumn];
    publisher = map[publisherColumn];
    genre = map[genreColumn];
    rating = map[ratingColumn];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      publisherColumn: publisher,
      genreColumn: genre,
      ratingColumn: rating
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
