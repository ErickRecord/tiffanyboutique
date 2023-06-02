import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/models/categories_model.dart';
import 'package:tiffanyapp/src/models/clothes_model.dart';
import 'package:tiffanyapp/src/provider/providers.dart';
import 'package:tiffanyapp/src/tools/validations.dart';
import 'package:tiffanyapp/src/widgets/widgets.dart';

class ClothesDetailsPage extends StatefulWidget {
  // Solicito parametros
  final ClothesModel? prenda;
  final bool estaComprando;
  const ClothesDetailsPage({super.key, this.prenda, required this.estaComprando});

  @override
  State<ClothesDetailsPage> createState() => _ClothesDetailsPageState();
}

// Estas opciones son las del DropDownMenu
  String opcionColor = "Blanco";
  int opcionCategoria = 1;
  // El mapa cambiara y guardara el valor de los inputs
  Map<String, dynamic> mapa = Map.fromEntries([
    MapEntry("color", opcionColor),
    MapEntry("categoria", opcionCategoria)
  ]);

class _ClothesDetailsPageState extends State<ClothesDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Si existe la prenda los inputs tomaran sus valores
    if (widget.prenda != null) {
      codigoController.text = widget.prenda!.codigo;
      nombreController.text = widget.prenda!.nombre;
      existenciaController.text = widget.prenda!.existencia.toString();
      precioController.text = widget.prenda!.precio.toString();
      mapa["color"] = widget.prenda!.color;
      mapa["categoria"] = widget.prenda!.idCategoria;
    } else{
      // Si no les dejare un valor por defecto
      WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ClothesProvider>(context, listen: false).setFoto = null;
      });
      mapa["color"] = "Blanco";
      mapa["categoria"] = 1;
    }
  }
  // Este sera el valor del formulario
  GlobalKey<FormState> formulario = GlobalKey<FormState>();



// Controlador de los inputs
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController existenciaController = TextEditingController();
  TextEditingController precioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Realizo instancia del provider
    final clothesProvider = Provider.of<ClothesProvider>(context);
    return Scaffold(
      // Agrego un appbar vacio
      appBar: AppBar(),
      // Indico que tendrs scroll la pagina
      body: SingleChildScrollView(
        // Una sepracion y coluna
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Stack lo puso para poner un widget encima de otro, en este caso sera la imagen y un IconButton
              Stack(
                children: [
                  // Si la foto a tomar no esta vacia
                  (clothesProvider.getFoto != null)
                      // Regreso la imagen tomada
                      ? Image.memory(clothesProvider.getFoto!, height: 350, fit: BoxFit.cover)
                      // En caso de que la prenda exista
                      : (widget.prenda != null)
                          // Se mostrara la imagen de esa prenda
                          ? Image.memory(widget.prenda!.imagen!,
                              height: 350, fit: BoxFit.cover)
                          // Si no entra en ninguna muestra una imagen por defecto
                          : Image.asset("assets/no-imagen.png",
                              height: 350, fit: BoxFit.cover),
                  // Coloco el IconButton abajo en la derecha
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                          // En caso de presionar el boton se abrira una alerta
                          onPressed: () =>  (!widget.estaComprando)?
                          showCupertinoDialog(
                              // barrierDismissible indica si al presionar alrededor de la alerta se podra cerrar al ponerla en true se cierra
                              barrierDismissible: true,
                              context: context,
                              // Despues creo una clase privada a la cual le mando la misma funcion pero con diferente parametro
                              builder: (_) => _AlertaWidget(
                                    funcionBotonIzquierdo: () =>
                                        _agregarFoto(ImageSource.camera,clothesProvider),
                                    funcionBotonDerecho: () =>
                                        _agregarFoto(ImageSource.gallery,clothesProvider),
                                  ))
                                  : null,
                          // Le ponog su icono al boton
                          icon: const FaIcon(FontAwesomeIcons.camera)))
                ],
              ),
              // Defino un formulario
              Form(
                // Le asigno la variable del GlobalKey
                key: formulario,
                child: Column(children: [
                  // Coloco las opciones de las prendas con sus parametros solicitados
                  _Opcion(
                    estaComprando: widget.estaComprando,
                    maxLength: 5,
                      tipo: TextInputType.number,
                      textoOpcion: "Codigo:",
                      esInputText: true,
                      controller: codigoController,
                      validator: (valor) => Validations.valCodigo(valor!)),
                  _Opcion(
                    estaComprando: widget.estaComprando,
                      textoOpcion: "Nombre:",
                      esInputText: true,
                      controller: nombreController,
                      validator: (valor) => Validations.valNombre(valor!)),
                  _Opcion(
                    estaComprando: widget.estaComprando,
                    tipo: TextInputType.number,
                      textoOpcion: "Existencias:",
                      esInputText: true,
                      controller: existenciaController,
                      validator: (valor) => Validations.valExistencias(valor!)),
                  _Opcion(
                    estaComprando: widget.estaComprando,
                    tipo: TextInputType.number,
                      textoOpcion: "Precio:",
                      esInputText: true,
                      controller: precioController,
                      validator: (valor) => Validations.valPrecio(valor!)),
                  _Opcion(
                    estaComprando: widget.estaComprando,
                      textoOpcion: "Color:",
                      esInputText: false,
                      lista: itemsColores(clothesProvider.color),
                      keyMapa: "color",),
                  _Opcion(
                    estaComprando: widget.estaComprando,
                      textoOpcion: "Categoria:",
                      esInputText: false,
                      lista: itemsCategorias(clothesProvider.listaCategorias),
                      keyMapa: "categoria"),
                  // Coloco un boton pa guardar
                  ButtonWidget(
                    texto: "Guardar",
                    funcion: () {
                      // Si el formulario se valida correctamente
                      if(formulario.currentState!.validate()){
                      // Se creara un modelo tipo ClothesModel 
                      ClothesModel prenda = ClothesModel(idPrenda: (widget.prenda != null)?widget.prenda!.idPrenda:null,imagen: clothesProvider.getFoto,codigo: codigoController.text,nombre: nombreController.text,existencia: int.parse(existenciaController.text),precio: double.parse(precioController.text),color: mapa["color"],idCategoria: mapa["categoria"],bandera: 1);
                      // Si la prenda mandada por parametros es != de null editara la prenda
                      if (widget.prenda != null) {
                        clothesProvider.editarPrenda(prenda);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Prenda editada")));
                      } else {
                        // Caso contrario valido si la foto es vacia para mandar un mensaje de error
                        if (clothesProvider.getFoto == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Selecciona una foto para continuar")));
                        } else {
                          // Si si no entra en las anteriores registrara las prendas
                          registrarPrenda(clothesProvider, prenda);
                          Provider.of<SalesProvider>(context,listen: false).consultarTotalPrendas();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Prenda registrada")));
                        }
                      }
                      }
                    },
                    esTamanoCompleto: true,
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Estas listas son las del DropdownMenu.
  // Solicito una lista
  List<DropdownMenuItem<String>>? itemsColores(List listaColores) {
    // Creo una variable local
    List<DropdownMenuItem<String>> lista = [];
    // Recorro la lista en base al tamaño a la lista solicitada
    for (int i = 0; i < listaColores.length; i++) {
      // La variable local tomara DropdownMenuItem la cual se llena con la info de la lista solicitada
      lista.add(DropdownMenuItem(
          value: listaColores[i].toString(),
          child: Text(listaColores[i].toString())));
    }
    // Retorno la lista
    return lista;
  }
  // Lo mismo aca
  List<DropdownMenuItem<int>>? itemsCategorias(
      List<CategoriesModel> listaCategorias) {
    List<DropdownMenuItem<int>> lista = [];
    for (int i = 0; i < listaCategorias.length; i++) {
      lista.add(DropdownMenuItem(
          value: listaCategorias[i].idCategoria,
          child: Text(listaCategorias[i].nombre)));
    }
    return lista;
  }

  // Este metodo es para registrar
  void registrarPrenda(ClothesProvider clothesProvider, ClothesModel prenda) {
    clothesProvider.registarPrenda(prenda);
    // Ya una vez creado el objeto se limpian los inputs y la foto
    // formulario.currentState?.reset();
    clothesProvider.setFoto = null;
    codigoController.text = "";
    nombreController.text = "";
    existenciaController.text = "";
    precioController.text = "";
    // opcionColor = "Blanco";
    opcionCategoria = 1;
  }


  // El metodo recibe un ImageSource el cual indica si se esta accediendo a la camara o galeria
  // el motodo es asincrono lo que se refiere a que tiene que esperar tiempo para realizar una accion
  void _agregarFoto(ImageSource imageSource ,ClothesProvider clothesProvider) async {
    // definimos una variable tipo ImagePicker
    final picker = ImagePicker();
    // XFile significa que trabajas con archivos por eso creamos una variable de ese tipo
    // despues un await para esperar a que se complete el picker para saber si se usara la camara o galeria
    // imageQuality sirve para ver la calidad de la foto
    final XFile? pickedFile =
        await picker.pickImage(source: imageSource, imageQuality: 100,maxHeight: 400);
    // Si no selecciono nada, este no retornara nada
    if (pickedFile == null) {
      return;
    }
    // Si guardo algo agrego la foto a la variable foto de tipo File
      // ignore: use_build_context_synchronously
        Navigator.pop(context);
      clothesProvider.setFoto = File(pickedFile.path).readAsBytesSync();
  }
}

class _Opcion extends StatelessWidget {
  // Solicito parametros
  final String? Function(String?)? validator;
  final List<DropdownMenuItem>? lista;
  final TextEditingController? controller;
  final String? keyMapa;
  final bool esInputText;
  final String textoOpcion;
  final int? maxLength;
  final bool estaComprando;
  final TextInputType? tipo;
  const _Opcion(
      {Key? key,
      required this.textoOpcion,
      required this.esInputText,
      this.validator,
      this.lista,
      this.controller, this.keyMapa, required this.estaComprando, this.maxLength, this.tipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // MediaQuery sirve para tomar medidas del dispotivo para hacerlo adaptable
              SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Text(
                    textoOpcion,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              // Le indico si sera input o DropDown
              Expanded(
                  child: (esInputText)
                      ? _InputRopa(
                        tipo: tipo,
                        estaComprando: estaComprando,
                          validator: validator,
                          controller: controller,
                          maxLength: maxLength,
                        )
                      : _DropdownButton(
                        estaComprando: estaComprando,
                          lista: lista!,
                          keyMapa: keyMapa,
                        )),
            ],
          ),
        ),
        const Divider()
      ],
    );
  }
}

class _DropdownButton extends StatefulWidget {
  final String? keyMapa;
  final List<DropdownMenuItem> lista;
  final bool estaComprando;
  const _DropdownButton({
    Key? key,
    required this.lista, this.keyMapa, required this.estaComprando,
  }) : super(key: key);

  @override
  State<_DropdownButton> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<_DropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      // Le dejo un redondeado
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      decoration: const InputDecoration(
        // Le quito el padding interno
        contentPadding: EdgeInsets.zero,
      ),
      // Los item se los paso por parametro
      items: widget.lista,
      // El valor tambien viene por parametro
      value: mapa[widget.keyMapa!],
      // Al cambiar valido si esta comprando para desactivarlo 
      onChanged: (widget.estaComprando)
      // Si esta comprando este no se podra editar
      ? null
      // Caso contrario si
      : (dynamic valor){
        setState(() {
          mapa[widget.keyMapa!] = valor;
        });
      },
    );
  }
}

class _InputRopa extends StatelessWidget {
  // Solicito parametros
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final TextInputType? tipo;
  final bool estaComprando;
  const _InputRopa({Key? key, required this.validator, this.controller, required this.estaComprando, this.maxLength, this.tipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: tipo,
      enabled: (estaComprando)? false:true,
      maxLength: maxLength,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 10), isDense: true),
    );
  }
}

class _AlertaWidget extends StatelessWidget {
  const _AlertaWidget(
      {required this.funcionBotonIzquierdo, required this.funcionBotonDerecho});
  final Function funcionBotonIzquierdo;
  final Function funcionBotonDerecho;

  @override
  Widget build(BuildContext context) {
    // CupertinoAlertDialog lo uso pa mostrar las alertas tipo aifon
    return CupertinoAlertDialog(
      // Le asigno titulo a la alerta
      title: const Text("¿Como deseas agregar la foto?"),
      actions: [
        // Genero los botones de la alerta
        CupertinoDialogAction(
            onPressed: () => funcionBotonIzquierdo(),
            child: const Text("Foto")),
        CupertinoDialogAction(
          child: const Text("Galeria"),
          onPressed: () => funcionBotonDerecho(),
        ),
      ],
    );
  }
}
