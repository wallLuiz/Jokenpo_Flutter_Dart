import 'dart:math';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List opcoes = ["pedra", "papel", "tesoura"];

  String _mensagem = "Escolha uma opção";
  String _imagePath = "images/default.png";

  int maquina = 0;
  int jogador = 0;

  void _play(String choice) {
    int i = Random().nextInt(opcoes.length);
    String escolhaAleatoria = opcoes[i];
    _imagePath = "images/" + escolhaAleatoria + ".png";

    if ((choice == "pedra" && escolhaAleatoria == "tesoura") ||
        (choice == "papel" && escolhaAleatoria == "pedra") ||
        (choice == "tesoura" && escolhaAleatoria == "papel")) {
      jogador++;
      setState(() {
        _mensagem = "Você venceu =D";
      });
    } else if ((choice == "pedra" && escolhaAleatoria == "papel") ||
        (choice == "papel" && escolhaAleatoria == "tesoura") ||
        (choice == "tesoura" && escolhaAleatoria == "pedra")) {
      maquina++;
      setState(() {
        _mensagem = "Você perdeu =(";
      });
    } else {
      setState(() {
        _mensagem = "Empatamos ;)";
      });
    }

    if (jogador == 3 || maquina == 3) {
      setState(() {
        if (jogador == 3) {
          _mensagem = "🏆 Você venceu a melhor de 3!";
        } else {
          _mensagem = "💻 A máquina venceu a melhor de 3!";
        }
      });

      jogador = 0;
      maquina = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Você $jogador x $maquina Máquina",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
          backgroundColor: Colors.green,

      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                "Escolha da máquina",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(_imagePath, height: 150),
            Padding(
              padding: EdgeInsets.only(top: 32, bottom: 16),
              child: Text(
                _mensagem,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _play("pedra"),
                  child: Image.asset("images/pedra.png", height: 100),
                ),
                GestureDetector(
                  onTap: () => _play("papel"),
                  child: Image.asset("images/papel.png", height: 100),
                ),
                GestureDetector(
                  onTap: () => _play("tesoura"),
                  child: Image.asset("images/tesoura.png", height: 100),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
