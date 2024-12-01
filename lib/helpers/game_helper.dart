import 'package:app_jogos/Enums/e_genres.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String idColumn = "idColumn";
String nameColumn = "nameColumn";
String publisherColumn = "publisherColumn";
String genreColumn = "genreColumn";
String ratingColumn = "ratingColumn";
String gameTable = "gameTable";

class GameHelper {
  static final GameHelper _instance = GameHelper._internal();
  factory GameHelper() => _instance;

  late Database _db;

  GameHelper._internal();

  // Inicializa o banco de dados
  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'game_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE games(idColumn INTEGER PRIMARY KEY, nameColumn TEXT, publisherColumn TEXT, genreColumn TEXT, ratingColumn TEXT)',
        );
      },
      version: 1,
    );
  }

  // Função para salvar um jogo
  Future<Game> saveGame(Game game) async {
    Database db = await _db;
    game.id = await db.insert('games', game.toMap());
    return game;
  }

  // Função para atualizar um jogo
  Future<int> updateGame(Game game) async {
    Database db = await _db;
    return db.update(
      'games',
      game.toMap(),
      where: 'idColumn = ?',
      whereArgs: [game.id],
    );
  }

  // Função para recuperar todos os jogos
  Future<List<Game>> getAllGames() async {
    Database db = await _db;
    List<Map<String, dynamic>> maps = await db.query('games');
    return List.generate(maps.length, (i) {
      return Game.fromMap(maps[i]);
    });
  }
}

class Game {
  int? id;
  String? name;
  String? publisher;
  Genre? genre; // Usando o enum Genre
  String? rating;

  Game();

  // Método para converter o banco de dados para um objeto Game
  Game.fromMap(Map<String, dynamic> map) {
    id = map['idColumn'];
    name = map['nameColumn'];
    publisher = map['publisherColumn'];
    genre = _getGenreFromString(map['genreColumn']);
    rating = map['ratingColumn'];
  }

  // Método para converter o enum para string e armazenar no banco
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nameColumn': name,
      'publisherColumn': publisher,
      'genreColumn': genre?.nome, // Armazenando o nome do enum
      'ratingColumn': rating,
    };
    if (id != null) {
      map['idColumn'] = id;
    }
    return map;
  }

  // Função auxiliar para obter o enum de uma string
  Genre? _getGenreFromString(String? genreString) {
    if (genreString == null) {
      return null;
    }
    return Genre.values.firstWhere((e) => e.nome == genreString);
  }
}
