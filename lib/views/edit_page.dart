import 'package:app_jogos/helpers/game_helper.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final Game? game;

  EditPage({this.game});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _nameController = TextEditingController();
  final _publisherController = TextEditingController();
  final _genreController = TextEditingController();
  final _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.game != null) {
      _nameController.text = widget.game!.name ?? '';
      _publisherController.text = widget.game!.publisher ?? '';
      _genreController.text = widget.game!.genre ?? '';
      _ratingController.text = widget.game!.rating ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game == null ? "Novo Jogo" : "Editar Jogo"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nome do Jogo",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _publisherController,
              decoration: InputDecoration(
                labelText: "Publisher",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _genreController,
              decoration: InputDecoration(
                labelText: "Gênero",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Avaliação (0-10)",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveGame() {
    if (_nameController.text.isNotEmpty) {
      Game game = Game();
      game.name = _nameController.text;
      game.publisher = _publisherController.text;
      game.genre = _genreController.text;
      game.rating = _ratingController.text;

      Navigator.pop(context, game);
    } else {
      // Exibe um alerta se o nome do jogo não for preenchido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("O nome do jogo é obrigatório!"),
        ),
      );
    }
  }
}
