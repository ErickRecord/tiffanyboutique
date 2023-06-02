import 'package:flutter/material.dart';

//StatelessWidget indica que este widget se no se redibuja
class InputWidget extends StatefulWidget {
  // Solicito parametros
  final String label;
  final IconData icono;
  final bool? esPassword;
  final String? Function(String?)? validacion;
  final TextEditingController control;
  const InputWidget(
      {super.key,
      required this.label,
      required this.icono,
      this.validacion,
      required this.control,
      this.esPassword});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    // ConstrainedBox se usa para dejar un espacio definido al widget
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            // Defino sus tamaños
            maxHeight: 80,
            minHeight: 80),
        // TextFormField es el input
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.control,
          obscureText: (widget.esPassword != null) ? true : false,
          validator: widget.validacion,
          // decoration es la decoracion
          decoration: InputDecoration(

              // De titulo se lo mando por parametro, al igual que el icono
              label: Text(widget.label),
              prefixIcon: Icon(widget.icono),
              // Le quito el borde por defult
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
        ),
      ),
    );
  }
}
