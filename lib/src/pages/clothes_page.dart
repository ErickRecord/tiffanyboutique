import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/provider/providers.dart';
import 'package:tiffanyapp/src/widgets/button_widget.dart';

class ClothesPage extends StatefulWidget {
  // Solito parametros
  final bool estaComprando;
  const ClothesPage({super.key, required this.estaComprando});

  @override
  State<ClothesPage> createState() => _ClothesPageState();
}
// Indico los contraladores de los buscadores
TextEditingController codigoController = TextEditingController();
TextEditingController nombreController = TextEditingController();

class _ClothesPageState extends State<ClothesPage> {
  // Tambien de scroll
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final clothesProvider = Provider.of<ClothesProvider>(context, listen: false);
    // Al entrar a la pagina si esta comprando se limpiara el carrito y el mapa
    if (widget.estaComprando) {
      clothesProvider.listaPrendasCarrito.clear();
      clothesProvider.mapa.clear();
    }
    // WidgetsBinding espera a que se obtenga el context y no ejecute un error el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reinicio los buscadores
      clothesProvider.setColorSeleccionado = "";
      clothesProvider.setIdCatSeleccionada = 0;
      clothesProvider.reiniciarCont();
      clothesProvider.consultarPrendas(0);
    });
    nombreController.clear();
    codigoController.clear();
    // Asigno el scroll
    scrollController.addListener(() => _scroll());
  }

  void _scroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      Provider.of<ClothesProvider>(context, listen: false).masDatos();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // Al salir de lpagina el evento se eliminara
    scrollController.removeListener(() => _scroll());
  }

  @override
  Widget build(BuildContext context) {
    // Realizo instancia del provider
    final clothesProvider = Provider.of<ClothesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        // El appbar se mostrar un icono que mostrara el sistema de busqueda avanzado
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            // Al presionar le icono de lista se abrira un showModalBottomSheet
            onPressed: () => showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                context: context,
                builder: (_) => const _FiltroBuscador()),
          )
        ],
      ),
      // Indico que la pagina tendra scroll
      body: SingleChildScrollView(
        controller: scrollController,
        // Genero una columna que tendra el input de buscar y una lista
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                    width: 100,
                    child: _InputBuscar(
                      hintText: "Codigo",
                      controller: codigoController,
                    )),
                Expanded(
                    child: _InputBuscar(
                  hintText: "Buscar...",
                  controller: nombreController,
                )),
                IconButton(
                  // Al precionar el boton de buscar se redibuja la lista que guarda las prendas
                    onPressed: () {
                      clothesProvider.consultarPrendas(0,
                          estaBuscando: true,
                          codigo: codigoController.text,
                          nombre: nombreController.text,
                          color: clothesProvider.getColorSeleccionado,
                          idCategoria: clothesProvider.getIdCatSeleccionada);
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            // Si la lista no es vacia la muestro. Caso contrario indico que no tienen ninguna prenda
            (clothesProvider.listaPrendas.isNotEmpty)
            ? _ListaPrendas(clothesProvider: clothesProvider, widget: widget)
            : const Text("No tienes ninguna prenda")
          ],
        ),
      ),
      // En caso de que este comprando se mostrar un boton flotante y si es falso no se mostrara
      floatingActionButton: (widget.estaComprando)
          ? FloatingActionButton.extended(
              backgroundColor: Colors.white,
              onPressed: () =>(clothesProvider.listaPrendasCarrito.isNotEmpty)
              ? Navigator.push(context,CupertinoPageRoute(builder: (_) =>  TotalSalePage(listaPrenda: clothesProvider.listaPrendasCarrito,)))
              : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecciona minimo una prenda"))),
              label: const Text("Continuar"))
          : null,
    );
  }
}

class _ListaPrendas extends StatelessWidget {
  const _ListaPrendas({
    Key? key,
    required this.clothesProvider,
    required this.widget,
  }) : super(key: key);

  final ClothesProvider clothesProvider;
  final ClothesPage widget;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // Indico que la lista puede crecer
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        // Numero de elentos
        itemCount: clothesProvider.listaPrendas.length,
        itemBuilder: (_, int i) {
          // retorno la tarjeta
          return ClothesCardWidget(
            estaEnCarrito: false,
            estaComprando: widget.estaComprando,
            prenda: clothesProvider.listaPrendas[i],
          );
        });
  }
}

class _InputBuscar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const _InputBuscar({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            fillColor: Theme.of(context).secondaryHeaderColor,
            filled: true,
            border: InputBorder.none),
      ),
    );
  }
}

class _FiltroBuscador extends StatelessWidget {
  const _FiltroBuscador({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clothesProvider = Provider.of<ClothesProvider>(context);
    // Regreso una columna
    return Column(
      children: [
        // Le dejo algo de separacion
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text("Filtro", style: TextStyle(fontSize: 20)),
        ),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(10),
          child: Text("Categoria"),
        ),
        // Genero un GridView para mostrar las categorias
        _Categorias(clothesProvider: clothesProvider),
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text("Colores"),
        ),
        _Colores(clothesProvider: clothesProvider),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ButtonWidget(
            texto: "Buscar",
            esTamanoCompleto: true,
            funcion: () {
              clothesProvider.consultarPrendas(0,
                  estaBuscando: true,
                  codigo: codigoController.text,
                  nombre: nombreController.text);
            },
          ),
        )
      ],
    );
  }
}

class _Colores extends StatelessWidget {
  const _Colores({
    Key? key,
    required this.clothesProvider,
  }) : super(key: key);

  final ClothesProvider clothesProvider;

  @override
  Widget build(BuildContext context) {
    // Genero una lista de colores
    final List<Color> color = [
      Colors.white,
      Colors.black,
      Colors.grey,
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.orange,
      Colors.brown,
      Colors.pink,
      Colors.purple,
    ];
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: clothesProvider.color.length,
        // Indico que por fila tendra 8 elementos
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        // Genero el contador
        itemBuilder: (_, int i) {
          return GestureDetector(
            onTap: () {
              // Si el color seleccionado es igual al del color en la posicion i
              (clothesProvider.getColorSeleccionado == clothesProvider.color[i])
              // Se limpiara el color seleccionado
                  ? clothesProvider.setColorSeleccionado = ""
              // Caso contrario se marca para despues buscarlo
                  : clothesProvider.setColorSeleccionado =
                      clothesProvider.color[i];
            },
            child: Padding(
              // Agrego separacion
              padding: const EdgeInsets.all(5),
              // Borde redondeado
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                child: Container(
                  // Aplica la misma validacion que la anterior. Si se cumple se coloca un color gris
                  color: (clothesProvider.getColorSeleccionado ==
                          clothesProvider.color[i])
                      ? const Color.fromARGB(255, 228, 228, 228)
                      // Si no no se pondra ninguno
                      : Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 5,
                      width: 5,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: color[i]),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

// Categorias es exactamente igual al anterior
class _Categorias extends StatelessWidget {
  const _Categorias({
    Key? key,
    required this.clothesProvider,
  }) : super(key: key);

  final ClothesProvider clothesProvider;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: clothesProvider.listaCategorias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 2.5),
        itemBuilder: (_, int i) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: (clothesProvider.getIdCatSeleccionada ==
                          clothesProvider.listaCategorias[i].idCategoria)
                      ? Colors.white
                      : Colors.black),
              child: Text(
                clothesProvider.listaCategorias[i].nombre,
                style: TextStyle(
                    color: (clothesProvider.getIdCatSeleccionada ==
                            clothesProvider.listaCategorias[i].idCategoria)
                        ? Colors.black
                        : Colors.white),
              ),
              onPressed: () {
                (clothesProvider.getIdCatSeleccionada ==
                        clothesProvider.listaCategorias[i].idCategoria)
                    ? clothesProvider.setIdCatSeleccionada = 0
                    : clothesProvider.setIdCatSeleccionada =
                        clothesProvider.listaCategorias[i].idCategoria;
              },
            ),
          );
        });
  }
}
