import 'dart:async';
import 'package:app_jogos/helpers/game_helper.dart';
import 'package:app_jogos/views/edit_page.dart';
import 'package:flutter/material.dart';

enum OrderOptions { orderNameAsc, orderNameDesc }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameHelper helper = GameHelper();
  List<Game> games = [];

  @override
  void initState() {
    super.initState();
    _getAllGames();
  }

  void _getAllGames() {
    helper.getAllGames().then((list) {
      setState(() {
        games = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Jogos"),
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            onSelected: _orderList,
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome (A-Z)"),
                value: OrderOptions.orderNameAsc,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome (Z-A)"),
                value: OrderOptions.orderNameDesc,
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditPage();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          return _gameCard(context, index);
        },
      ),
    );
  }

  Widget _gameCard(BuildContext context, int index) {
    return Card(
      child: ListTile(
        title: Text(games[index].name ?? "Sem Nome"),
        subtitle: Text("Gênero: ${games[index].genre ?? "Desconhecido"}"),
        onTap: () {
          _showEditPage(game: games[index]);
        },
      ),
    );
  }

  Future<void> _showEditPage({Game? game}) async {
    final updatedGame = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPage(game: game)),
    );
    if (updatedGame != null) {
      if (game != null) {
        await helper.updateGame(updatedGame);
      } else {
        await helper.saveGame(updatedGame);
      }
      _getAllGames();
    }
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderNameAsc:
        games.sort((a, b) => a.name!.compareTo(b.name!));
        break;
      case OrderOptions.orderNameDesc:
        games.sort((a, b) => b.name!.compareTo(a.name!));
        break;
    }
    setState(() {});
  }
}
