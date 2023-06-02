import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/models/clothes_model.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/provider/clothes_provider.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';
import 'package:tiffanyapp/src/widgets/alerta_widget.dart';

class ClothesCardWidget extends StatefulWidget {
  // Solicito parametros
  final ClothesModel prenda;
  final bool estaComprando;
  final bool estaEnCarrito;
  const ClothesCardWidget(
      {Key? key, required this.estaComprando, required this.prenda, required this.estaEnCarrito})
      : super(key: key);

  @override
  State<ClothesCardWidget> createState() => _ClothesCardWidgetState();
}

class _ClothesCardWidgetState extends State<ClothesCardWidget> {
  @override
  Widget build(BuildContext context) {
    final clothesProvider = Provider.of<ClothesProvider>(context);
    // Le asigno estilo a los textos
    TextStyle estilo = const TextStyle(color: Color.fromARGB(255, 146, 145, 145));
    // GestureDetector pa en caso de que presione una tarjeta
    return GestureDetector(
      onLongPress: ()=>(Preferences.idAdmin == 1)
      ? showCupertinoDialog(context: context, builder: (_)=>AlertaWidget(funcion: ()=>clothesProvider.eliminarPrenda(widget.prenda.idPrenda!, context),mensaje: "¿Estas seguro de borrar la prenda?",))
      : null,
      // Al presionar una lista te mandara a ClothesDetailsPage
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (_) => ClothesDetailsPage(prenda: widget.prenda, estaComprando: widget.estaComprando,))),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          // Genero una fila la cual dara espacio a la imagen y los detalles
          child: Row(
            // Aparezco los detalles al inicio
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Coloco la imagen con un tamaño fijo
              Image.memory(
                widget.prenda.imagen!,
                height: 150,
                width: 150,
              ),
              // Asigno una separacion
              const SizedBox(width: 20),
              // Flexible sirve para que en caso de que el texto llegue al final del widget, este hara que baje de linea y no se rompa
              Flexible(
                // Genero una columna
                child: Column(
                  // Aparezco los detalles al inicio
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.prenda.nombre,
                      style: const TextStyle(fontSize: 19),
                    ),
                    const SizedBox(height: 10),
                    Text("Precio: \$${widget.prenda.precio}", style: estilo),
                    const SizedBox(height: 10),
                    Text("Existencias: ${widget.prenda.existencia}",style: estilo),
                    if(widget.estaEnCarrito)
                    Column(
                      children: [
                      const SizedBox(height: 20),
                        Text("Cantidad: ${clothesProvider.mapa[widget.prenda.idPrenda]}", style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.estaComprando && !widget.estaEnCarrito && widget.prenda.existencia != 0)
                      _Contador(
                        prenda: widget.prenda,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Contador extends StatefulWidget {
  final ClothesModel prenda;
  const _Contador({
    Key? key,
    required this.prenda
  }) : super(key: key);

  @override
  State<_Contador> createState() => _ContadorState();
}

class _ContadorState extends State<_Contador> {
  // Variable temp
  int cont = 0;

  @override
  Widget build(BuildContext context) {
    final clothesProvider = Provider.of<ClothesProvider>(context);
    cont = clothesProvider.mapa[widget.prenda.idPrenda] ?? 0;
    // Indico que es un contenedor, bordes redondeados, y color de fondo blanco
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      // Agrego una fila
      child: Row(
        // Indico que tome el tamaño minimo
        mainAxisSize: MainAxisSize.min,
        children: [
          // Agrego dos botones los cuales incremente y decrementen la existencia a vender
          _boton(FontAwesomeIcons.minus, () {
            // Para evitar valores negativos valido si es mayor a 0
            if (cont > 0) {
              // incremente
              cont--;
              _funcion(clothesProvider, cont);
            }
            // setState se usa para redibujar la variable
            setState(() {});
          }, const Color.fromARGB(255, 212, 212, 212)),
          // Le defino un tamaño maximo texto del contador
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 30, minWidth: 30),
              child: Center(
                  child: Text(
                "$cont",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ))),
          _boton(
              FontAwesomeIcons.plus,
              () => setState(() {
                    // Para evitar valores que superen la existencia valido si es menor a la existencia
                    if (cont < widget.prenda.existencia) {
                      // Si es asi lo incremento
                      cont++;
                      _funcion(clothesProvider, cont);
                    }
                  }),
              const Color.fromARGB(255, 167, 166, 166))
        ],
      ),
    );
  }

  void _funcion(ClothesProvider clothesProvider, int cont) {
    if (cont > 0) {
      if (clothesProvider.mapa[widget.prenda.idPrenda] == null) {
        clothesProvider.listaPrendasCarrito.add(widget.prenda);
      }
      clothesProvider.mapa.addAll({widget.prenda.idPrenda!: cont});
    } else {
      clothesProvider.mapa.remove(widget.prenda.idPrenda);
      clothesProvider.listaPrendasCarrito.remove(widget.prenda);
   
    }

  }

  Widget _boton(IconData icono, VoidCallback funcion, Color color) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            // Le quito el margin y defino un padding
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(10),
            backgroundColor: color,
            // Redondeo los bordes
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))),
        onPressed: funcion,
        child: FaIcon(
          icono,
          color: Colors.black,
        ));
  }
}
