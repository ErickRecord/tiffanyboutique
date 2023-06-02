import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiffanyapp/src/db/db.dart';
import 'package:tiffanyapp/src/models/administrator_model.dart';
import 'package:tiffanyapp/src/models/types_admins_model.dart';
import 'package:tiffanyapp/src/pages/home_page.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';

// Esta clase manejara el estado de Administradores
class AdministratorProvider extends ChangeNotifier {
  // Esta variable manejara el estado del formulario
  GlobalKey<FormState> formulario = GlobalKey<FormState>();

  // Valido si ya se valido el formulario
  bool formularioValido(){
    return formulario.currentState?.validate() ?? false;
  }

  // Estas variables guardan el total dede ventas y ganancias de cada admin
  int totalVentas = 0;
  double totalGanancias = 0;

// Este sera el contador de la paginacion
  int _pagina = 0;
  // Este bool me indicara si ya no existen mas administrares
  bool _max = false;

  // Este metodo sirve para que cada vez que llegues al final este traigas mas datos
  void incrementarPagina() {
    _pagina++;
    _consultarAdmins(_pagina);
  }
  // Esta es la lista que se llenara a base de consultas
  List<AdministratorModel> listaAdmins = [];
  List<TypeAdminModel> listaTiposAdmins = [];

  // El constructor que solo se genera una vez
  AdministratorProvider() {
    _consultarAdmins(0);
    consultarTipoAdmin();
  }
  // Este metodo trae la informacion
  void _consultarAdmins(int pagina) async {
    // Espero a que se logre la consulta
    await DB.consultarAdmins(pagina).then((value) {
      // Valido si esta vacia es por que ya no traera mas datos la consulta
      if (value.isEmpty){
        _max = true;
        // Caso contrario agregara mas a la lista
      } else{
      listaAdmins.addAll(value);
      }
    });
    //Redibujo la lista
    notifyListeners();
  }
  // Para eliminar solicito el id y la posicion por
  // id pos para saber quien es
  // pos para que se elimina graficamente
  void eliminarAdmin(int idAdmin, int pos) async {
    await DB.eliminarAdmin(idAdmin).then((value){
      listaAdmins.removeAt(pos);
    });
    notifyListeners();
  }

  // Este metodo lo uso cuando hago scroll para validar si traer mas o no
  void masDatos() {
    // Si aun no llega al maximo agrego elementos a la lista
    if (!_max) {
      incrementarPagina();
    }
  }

  Future<bool> registrarAdmin(AdministratorModel admin, bool esPrimeraVez, BuildContext context) async {
    // LLamo al metodo para registrar de la db
    await DB.registrarAdmin(admin).then((value) {
      // Valido si es la primera vez que esta cuente como el dueño
      if (esPrimeraVez) {
        Preferences.esPrimeraVez = false;
        Preferences.idAdmin = value;
        Preferences.idTipo = admin.idTipo!;
        Preferences.nombre = admin.nombre;
        Preferences.usuario = admin.usuario;
        Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (_)=>const HomePage()), (route) => false);
      } else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Administrador registrado")));
      }
      // Reinicio el contador y mando a llamar la lista
      _pagina = 0;
      // Limpio la lista para traer mas datos
      listaAdmins.clear();
    _consultarAdmins(_pagina);
    return true;
    });
    return false;
  }

    void editarAdmin(int idAdmin, String nombre, String usuario, {String? password}) async {
    // LLamo al metodo para registrar de la db
    await DB.editarAdmin(idAdmin,nombre,usuario,password: password).then((value) {
      // Reinicio el contador y mando a llamar la lista
      _pagina = 0;
      // Limpio la lista para traer mas datos
      listaAdmins.clear();
    _consultarAdmins(_pagina);
    });
  }

 void consultarTipoAdmin() async {
    await DB.consultarTipos().then((value) {
      listaTiposAdmins.addAll(value);
    });
    notifyListeners();
  }

  void consultarGananciasAdmin(int idAdmin) async{
    // Realizo una consulta para ver las ganancias de los admins
    await DB.consultarGananciasAdmin(idAdmin).then((value){
      // Le asigno las ganancias a las variables defininas anteriormente
      totalVentas = value[0].total as int;
      totalGanancias = value[0].totalGanancias ?? 0;
    });
    // Redibujo las variables
    notifyListeners();
  }

}
