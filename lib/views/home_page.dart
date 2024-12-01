import 'package:app_jogos/views/game_page.dart';
import 'package:flutter/material.dart';
import 'package:app_jogos/helpers/game_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> _games;

  @override
  void initState() {
    super.initState();
    _games = _getAllGames(); // Carrega os jogos ao iniciar a página
  }

  Future<List<Game>> _getAllGames() async {
    List<Game> games = await GameHelper().getAllGames();
    return games;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Jogos'),
      ),
      body: FutureBuilder<List<Game>>(
        future: _games,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Carregando
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar jogos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum jogo encontrado'));
          } else {
            List<Game> games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(games[index].name ?? 'Nome não disponível'),
                  subtitle: Text(
                      games[index].publisher ?? 'Publicadora não disponível'),
                  onTap: () {
                    // Navegar para editar o jogo, se necessário
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GamePage(game: games[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar para a tela de adicionar um novo jogo
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
