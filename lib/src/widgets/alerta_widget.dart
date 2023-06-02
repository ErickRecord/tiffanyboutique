import 'package:flutter/cupertino.dart';

class AlertaWidget extends StatelessWidget {
  // Solicito un pareametro
  final VoidCallback funcion;
  final String mensaje;
  const AlertaWidget({Key? key, required this.funcion, required this.mensaje,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Advertencia"),
      content: Text(mensaje),
      actions: [
        // Genero dos botones
        // En Cancelar solo cerrara la alerta
        // En Borrar solicito una funcion la cual sera borrar y cierro la ventana 
        CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context)),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: (){
            funcion();
            Navigator.pop(context);
          },
          child: const Text("Borrar"),
        ),
      ],
    );
  }
}
