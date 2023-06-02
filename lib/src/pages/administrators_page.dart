import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/models/administrator_model.dart';
import 'package:tiffanyapp/src/pages/pages.dart';
import 'package:tiffanyapp/src/provider/administrator_provider.dart';
import 'package:tiffanyapp/src/widgets/alerta_widget.dart';

class AdministratorsPage extends StatefulWidget {
  const AdministratorsPage({super.key});

  @override
  State<AdministratorsPage> createState() => _AdministratorsPageState();
}

class _AdministratorsPageState extends State<AdministratorsPage> {
// Este scroll lo uso para indicar el scroll en la lista
final ScrollController _scrollController = ScrollController();

// El init se ejecuta al entrar a la pantalla
@override
  void initState() {
    super.initState();
    // Al iniciar al scroll le genero un evento
    _scrollController.addListener(() => _scroll());
  }

  void _scroll() {
    // Valido cuando llegue al final para agregar mas elementos
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      Provider.of<AdministratorProvider>(context, listen: false).masDatos();
    }
  }
  // El dispose sirve para indicar acciones al cerrar la pantalla
  @override
  void dispose() {
    super.dispose();
    // Al cerrarla elimino el escuchador
    _scrollController.removeListener(()=>_scroll());
  }

  @override
  Widget build(BuildContext context) {
    // Aqui se realiza la instancia al provider 
    final administratorProvider = Provider.of<AdministratorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administradores"),
      ),
        // Indico que la lista puede crecer
      body: ListView.builder(
        controller: _scrollController,
        // Numero de elementos
        itemCount: administratorProvider.listaAdmins.length,
        itemBuilder: (_,int i){
          // retorno la tarjeta
          return _Tarjeta(lista: administratorProvider.listaAdmins, i: i,funcion: ()=>administratorProvider.eliminarAdmin(administratorProvider.listaAdmins[i].idAdmin!,i));
      }
      ),
      // FloatingActionButton es un boton floatante el cual usare para agregar admins
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const FaIcon(FontAwesomeIcons.userPlus),
        onPressed: ()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>const AdministratorPage(esPrimeraVez: false,))),
      ),
    );
  }


}


class _Tarjeta extends StatelessWidget {
  final List<AdministratorModel> lista;
  final int i;
  final VoidCallback funcion;
  const _Tarjeta({required this.lista, required this.i, required this.funcion});

  @override
  Widget build(BuildContext context) {
    return ListTile(
       // Genero un evento al dejar presionado un elemento de la lista
      // El cual me regrese una alerta
        onLongPress: () {
          // Cuando el idTipo es 1 (Dueño) no se podra eliminar
          if(lista[i].idTipo != 1){
            showCupertinoDialog(
          barrierDismissible: true,
          context: context,
          builder: (_) => AlertaWidget(funcion: funcion,mensaje: "¿Estas seguro que quieres borrar al administrador?",));
          }
        },
            onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (_)=>AdministratorPage(esPrimeraVez: false,administrador: lista[i],))),
            contentPadding: const EdgeInsets.all(20),
            leading: const FaIcon(FontAwesomeIcons.user,size: 60,),
            title:  Text(lista[i].nombre,style: const TextStyle(fontSize: 18)),
            trailing: Text(lista[i].tipo!),
          );
  }
}
