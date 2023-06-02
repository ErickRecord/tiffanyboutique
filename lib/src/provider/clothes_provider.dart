
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/db/db.dart';
import 'package:tiffanyapp/src/models/categories_model.dart';
import 'package:tiffanyapp/src/models/clothes_model.dart';
import 'package:tiffanyapp/src/models/sales_details_model.dart';
import 'package:tiffanyapp/src/models/sales_model.dart';
import 'package:tiffanyapp/src/provider/providers.dart';

class ClothesProvider extends ChangeNotifier{
 
// Utilizo un Uint8List para el uso de imagenes el cual se trabaja en bits
  Uint8List? _foto;
  Uint8List? get getFoto => _foto;

  // Genero un metodo set para cuando agregue la imagen de la ropa
 set setFoto(Uint8List? foto){
  _foto = foto;
  // Redibujo
  notifyListeners();
 }
  // Max indica si ya no existen mas prendas
  bool _max = false;
  // Pagina la uso para paginar la informacion
  int _pagina = 0;
  
  // Estos seran los valores del dropwdown
  int _idCatSeleccionada = 0;
  String _colorSeleccionado = "";
 
// Genero get y set de categorias y colores donde hare lo mismo que en Uint8List
  int get getIdCatSeleccionada => _idCatSeleccionada;

  set setIdCatSeleccionada(int idCatSeleccionada){
  _idCatSeleccionada = idCatSeleccionada;
  notifyListeners();
 }

String get getColorSeleccionado => _colorSeleccionado;

 set setColorSeleccionado(String colorSeleccionado){
  _colorSeleccionado = colorSeleccionado;
  notifyListeners();
 }

// Este metodo aumenta mas elemntos a la lista de prendas
void incrementarPagina(){
  _pagina++;
  consultarPrendas(_pagina);
}

// Con este reinicio la lista,pagina y max
void reiniciarCont(){
  _max = false;
  listaPrendas.clear();
  _pagina = 0;
}


  // Listas
  List<CategoriesModel> listaCategorias = [];
  List<ClothesModel> listaPrendas = [];
  List<ClothesModel> listaPrendasCarrito = [];

  // Este mapa lo usare para ventas, saber cuando esta en el carrito y cuantas prendas guardo
  Map<int,int> mapa = <int,int>{};

//  Lista de colores
  final List<String> color = [
    "Blanco",
    "Negro",
    "Gris",
    "Rojo",
    "Azul",
    "Amarillo",
    "Verde",
    "Naranja",
    "Cafe",
    "Rosa",
    "Purpura",
  ];

  // Contructor que se usa al declararse una vez
  ClothesProvider(){
  _consultarCategorias();
  }

  // Consulto a las cateogiras
  void _consultarCategorias() async{
    await DB.consultarCategorias().then((value)=>listaCategorias.addAll(value));
    // Redibujo la lista de categorias
    notifyListeners();
  }

  // Registro prenda solocitando el modelo de prenda
  void registarPrenda(ClothesModel prenda) async{
    // Al momento de registrar la prenda se reincia el contador
    await DB.registrarPrenda(prenda).then((value) => reiniciarCont());
  }


  void eliminarPrenda(int idPrenda, BuildContext context) async{
    // Elimino la prenda, redibujo las prendas y el total de las prendas en el dashboard
    await DB.eliminarPrenda(idPrenda).then((value) => reiniciarCont());
    consultarPrendas(0);
    // ignore: use_build_context_synchronously
    Provider.of<SalesProvider>(context,listen: false).consultarTotalPrendas();
  }
  

  void consultarPrendas(int pagina, {bool estaBuscando = false, int? idCategoria = 0, String? color = "", String codigo = "", String nombre = ""}) async{
    // Para consuktar solicito parametros opciones
    await DB.consultarPrendas(pagina, idCategoria: _idCatSeleccionada, color: _colorSeleccionado, codigo: codigo,nombre: nombre).then((value){
      // Si esta vacia
      if(value.isEmpty){
        // max se pone tre indicando que ya no hay mas elemntos
        _max = true;
        // Si esta buscando se reiniciara el contador
        if(estaBuscando){
          reiniciarCont();}
      } else{
        // Si esta buscando reinicia el contadoy y agrega la prenda
        if(estaBuscando){
        reiniciarCont();
        listaPrendas.addAll(value);
        } else{
        // Caso contrario agregara las prendas encontradas sin buscar
          listaPrendas.addAll(value);
        }
        
      }
    });
    notifyListeners();
  }
  // Mas datos se usa gracias al evento del scroll
  void masDatos(){
    // Si no esta vacia seguira agregando elementos a la lista de prendas
    if(!_max){
      incrementarPagina();
      _max = false;
    }
  }
  void editarPrenda(ClothesModel prenda) async{
  // Para editar las prendas solocito al modelo y redibujo las listas de prendas
    await DB.editarPrenda(prenda).then((value) => reiniciarCont());
    consultarPrendas(0);
    notifyListeners();
  }
  double totalVenta() {
  // Creo una variable local
    double total = 0;
      // Recorro la lista de carritos para calcular el total de todas las prendas seleccionadas
    for (var prenda in listaPrendasCarrito) {
      total += (mapa[prenda.idPrenda]! * prenda.precio);
    }
    // Regreso el total
    return total;
  }
    // Registrar ventas
    void registrarVenta(int idAdmin) async{
      // Primero registro la venta. Esta me regresara el id de la venta
      await DB.registrarVenta(SalesModel(idAdmin: idAdmin, fecha: DateFormat("yyyy-MM-dd").format(DateTime.now()),total: totalVenta())).then((idVenta) async{
        // Despues recorro la lista de carrito
        for (var prenda in listaPrendasCarrito) {
        // Mientras se recorre detallara la venta de los que se vendio
        await DB.registrarDetalleVenta(SalesDetailsModel(idVenta: idVenta, idPrenda: prenda.idPrenda!, cantidad: mapa[prenda.idPrenda]!, totalPrenda: (mapa[prenda.idPrenda]! * prenda.precio))).then((value) => null);
        // Se reducira la existencia al producto vendido
        await DB.editarExistencia(prenda.idPrenda!, mapa[prenda.idPrenda]!);
      }
      });
      
  }


}