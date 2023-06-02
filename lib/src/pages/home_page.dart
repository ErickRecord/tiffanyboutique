import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/provider/providers.dart';
import 'package:tiffanyapp/src/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    return Scaffold(
      // drawer indica el menu de hamburguesa que esta en la parte superior
      drawer: const NavigationWidget(),
      // Appbar es la barra superior
      appBar: AppBar(
        // titulo al appbar
        title: const Text("Tiffany Boutique"),
        centerTitle: true,
      ),
      // Indico que la pagina puede tener scroll
      body: SingleChildScrollView(
      // Dejo una separacion
        child: Padding(
          padding: const EdgeInsets.all(10),
          // Genero una columna la cual ponga los elementos a la izquierda o al inicio
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Genero un texto
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text("Dashboard", style: TextStyle(fontSize: 30)),
              ),
              _Formulario(),
              // Coloco 2 tarjetas mandando parametros
              _Tarjeta(
                titulo: "Prendas",
                numero: salesProvider.totalPrendas,
                colorFondo: const Color.fromARGB(255, 15, 15, 15),
                colorFondoBoton: const Color.fromARGB(255, 26, 25, 25),
                icono: Icons.list,
                funcion: () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => const ClothesPage(estaComprando: false,)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _Tarjeta(
                titulo: "Ganancia",
                numero: salesProvider.total,
                colorFondo: const Color.fromARGB(255, 46, 109, 9),
                colorFondoBoton: const Color.fromARGB(255, 27, 65, 6),
                icono: Icons.attach_money,
                funcion: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => EarningsPage(listaTotalVenta: salesProvider.listaVentas)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  final Color colorFondo;
  final Color colorFondoBoton;
  final String titulo;
  final IconData icono;
  final num numero;
  final VoidCallback funcion;
  const _Tarjeta(
      {required this.colorFondo,
      required this.colorFondoBoton,
      required this.titulo,
      required this.icono,
      required this.numero,
      required this.funcion});

  @override
  Widget build(BuildContext context) {
    // Aplico un borde redondeado a los hijos
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        // Asigno un color de fondo con una variable de parametros
        color: colorFondo,
        // Creo una columna que almacena una fila
        child: Column(
          children: [
            // Creo una fila que empieze desde la izquierda
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En los metodos explico la funcion de ellos mismos
                _detallesTarjeta(),
                _icono(icono)
              ],
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorFondoBoton,
                      // A este boton le quito el espacio por default para que se vea bonito
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: funcion,
                    child: const Text("Mas informacion")))
          ],
        ),
      ),
    );
  }

  Widget _icono(IconData icono) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Icon(
          icono,
          size: 70,
          color: Colors.white,
        ));
  }

  Widget _detallesTarjeta() {
    // Expando la columna para que el icono se vaya hasta la derecha
    return Expanded(
      child: Column(
        // Empiezo los elementos a la izquirda
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dejo una separacion ente el numero y texto
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$numero",
                  style: const TextStyle(fontSize: 40, color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    titulo,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Formulario extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
  final salesProvider = Provider.of<SalesProvider>(context);
    // Creo los controladres de los input, asignandoles por default la fecha actual y dando formato a la fecha
    TextEditingController controlFechaInicial = TextEditingController(text: DateFormat("dd/MM/yyyy").format(salesProvider.fechaMapa["fechaInicial"]!));
    TextEditingController controlFechaFinal = TextEditingController(text: DateFormat("dd/MM/yyyy").format(salesProvider.fechaMapa["fechaFinal"]!));
    // Regreso una columna
    return Column(
      children: [
        // Ingreso los inputs
        _InputFecha(formulario: salesProvider.fechaMapa,formularioKey: "fechaInicial",controller: controlFechaInicial, hintText: "Fecha inicial"),
        _InputFecha(formulario: salesProvider.fechaMapa,formularioKey: "fechaFinal",controller: controlFechaFinal, hintText: "Fecha Final"),
        ButtonWidget(texto: "Buscar", funcion: () =>salesProvider.consultarVentas(DateFormat("yyyy-MM-dd").format(salesProvider.fechaMapa["fechaInicial"]!),DateFormat("yyyy-MM-dd").format(salesProvider.fechaMapa["fechaFinal"]!)), esTamanoCompleto: false)
      ],
    );
  }
}

class _InputFecha extends StatelessWidget {
  // Solicito parametros
  final TextEditingController controller;
  final String hintText;
  final Map<String,DateTime> formulario;
  final String formularioKey;
  const _InputFecha({
    Key? key,
    required this.hintText,
    required this.controller, required this.formulario, required this.formularioKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dejo una sepracion
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
          controller: controller,
          // Indico que el input solo se puede presionar, es decir, no se puede escribir
          readOnly: true,
          decoration: InputDecoration(
            // Coloco diseños
              focusColor: Colors.transparent,
              hintText: hintText,
              suffixIcon: const Icon(Icons.date_range),
              fillColor: Theme.of(context).secondaryHeaderColor,
              filled: true),
              // Genero un evento al presionarlo
          onTap: () async {
            // Genero una variable de tipo DateTime la cual es asincrona la cual indica que se debe esperar a que se realice la tarea
            DateTime? fechaPicker = await showDatePicker(
                context: context,
                // Le paso el mapeo con su key, el signo de admiracion (!) indica que siempre recibira algo que no sea null
                initialDate: formulario[formularioKey]!,
                // Indico la fecha de inicio y de fin
                firstDate: DateTime(2022),
                lastDate: DateTime.now());
                // Si no se selecciona una fecha no guardara nada
            if (fechaPicker != null) {
              // Le asigno al mapeo en su key la fecha seleccionada
              formulario[formularioKey] = fechaPicker;             
              // Se la paso al input para que la muestre en pantalla ya formateada 
              controller.text = DateFormat("dd/MM/yyyy").format(formulario[formularioKey]!);
            }
          }),
    );
  }
}
