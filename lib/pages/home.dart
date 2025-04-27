import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List opcoes = ["pedra", "papel", "tesoura"];

  String _mensagem = "Escolha uma opção";
  String _imagePath = "images/default.png";
  String _escolhaUsuario = "";
  int maquina = 0;
  int jogador = 0;

  void _play(String choice) {
    int i = Random().nextInt(opcoes.length);
    String escolhaAleatoria = opcoes[i];
    _imagePath = "images/" + escolhaAleatoria + ".png";

    setState(() {
      _escolhaUsuario = choice;
    });

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
      Future.delayed(Duration(milliseconds: 500), () {
        if (jogador == 3) {
          _mostrarVideoFinal("🏆 Você venceu a melhor de 3!", "assets/videos/vitoria.mp4");
        } else {
          _mostrarVideoFinal("💻 A máquina venceu a melhor de 3!", "assets/videos/derrota.mp4");
        }
      });
    }
  }

  void _mostrarVideoFinal(String mensagem, String caminhoVideo) async {
    final controller = VideoPlayerController.asset(caminhoVideo);
    await controller.initialize();
    controller.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  mensagem,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.pause();
                  controller.dispose();
                  Navigator.of(context).pop();
                  setState(() {
                    _mensagem = "Escolha uma opção";
                    _imagePath = "images/default.png";
                    jogador = 0;
                    maquina = 0;
                    _escolhaUsuario = "";
                  });
                },
                child: Text("Jogar Novamente"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Jogo Pedra, Papel e Tesoura",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlueAccent.shade100,
                    Colors.blue.shade300,
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                // PLACAR SEPARADO
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Jogador",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$jogador",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Máquina",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "$maquina",
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 16),
                  child: Text(
                    "Escolha da máquina",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Image.asset(_imagePath, height: 150),
                Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 16),
                  child: Text(
                    _mensagem,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: opcoes.map((opcao) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _escolhaUsuario = opcao;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: _escolhaUsuario == opcao
                              ? Border.all(color: Colors.blue, width: 4)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Transform.scale(
                          scale: _escolhaUsuario == opcao ? 0.85 : 0.95,
                          child: Image.asset(
                            "images/$opcao.png",
                            height: 100,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (_escolhaUsuario.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      _play(_escolhaUsuario);
                    },
                    child: Text("Confirmar Escolha"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
