import 'package:aSensvy/config/theme.dart';
import 'package:flutter/material.dart';

class ListInformation extends StatelessWidget {
  Color color;
  String tiulo;
  String subtitulo;

  ListInformation(
      {super.key,
      required this.color,
      required this.tiulo,
      required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(left: 15, right: 15),
      height: 120,
      width: 240,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(
                0, 3), // deslocamento horizontal e vertical da sombra
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tiulo,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            subtitulo,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }
}

class OptionsGrid extends StatelessWidget {
  String imagem;
  String nome;
  void Function() onTap;

  OptionsGrid(
      {super.key,
      required this.imagem,
      required this.nome,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Color(0xffE4E9F7),
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryBgCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(
                  0, 3), // deslocamento horizontal e vertical da sombra
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    imagem,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              nome,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

class UserInformation extends StatelessWidget {
  String texto;
  String titulo;

  UserInformation({super.key, required this.texto, required this.titulo});

  @override
  Widget build(BuildContext context) {
    // Color(0xffE4E9F7),
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                titulo,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                texto,
                style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
