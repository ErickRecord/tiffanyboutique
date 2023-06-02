import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  // Solicito parametros
  final String texto;
  final VoidCallback funcion;
  final bool esTamanoCompleto;
  const ButtonWidget({super.key, required this.texto, required this.funcion, required this.esTamanoCompleto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Por parametros solicito si el boton tomara el tamaño completo o no
      width: (esTamanoCompleto) ? double.infinity: null,
      // Genero el boton
      child: ElevatedButton(
        // Le asigno su funcion la cual sera por parametro
        onPressed: funcion,
        //Asigno estilo
        style: ElevatedButton.styleFrom(
          // Le asigno un fondo negro
          backgroundColor: Colors.black
        ),
        child: Text(texto),
      ),
    );
  }
}