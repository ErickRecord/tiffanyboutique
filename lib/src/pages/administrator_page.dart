import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiffanyapp/src/models/administrator_model.dart';
import 'package:tiffanyapp/src/models/types_admins_model.dart';
import 'package:tiffanyapp/src/provider/administrator_provider.dart';
import 'package:tiffanyapp/src/tools/preferences.dart';
import 'package:tiffanyapp/src/tools/validations.dart';
import 'package:tiffanyapp/src/widgets/widgets.dart';

class AdministratorPage extends StatefulWidget {
  // Solicito parametros
  final AdministratorModel? administrador;
  final bool esPrimeraVez;
  const AdministratorPage({super.key, this.administrador, required this.esPrimeraVez});

  @override
  State<AdministratorPage> createState() => _AdministratorPageState();
}
// Esta opcion cambiara despues con el DropDown
  int _opcion = 2;
class _AdministratorPageState extends State<AdministratorPage> {
  // Genero los controladores de los inputs
  TextEditingController nombreCompletoController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Si existe el admin mostrara sus datos en los inputs y sus ganancias
    if(widget.administrador != null){
      nombreCompletoController.text = widget.administrador!.nombre;
      usuarioController.text = widget.administrador!.usuario;
      Provider.of<AdministratorProvider>(context, listen: false).consultarGananciasAdmin(widget.administrador!.idAdmin!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final administratorProvider = Provider.of<AdministratorProvider>(context);
    return Scaffold(
      // Pongo su appbar
      appBar: AppBar(
        title: Text((widget.esPrimeraVez)?"Registrar dueño":(widget.administrador!=null)?"Editar administrador":"Agregar administrador"),
      ),
      // Indico que pa pagina tendra scroll
      body: SingleChildScrollView(
        // Dejo una separacion para que no este tan pegado
        child: Padding(
          padding: const EdgeInsets.all(10),
          // Creo una columna para todo
          child: Column(
            // Coloco los inputs
            children: [
              // Agrego un icono con tamaño y separacion
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: FaIcon(
                  FontAwesomeIcons.user,
                  size: 150,
                ),
              ),
              // Indico que se sera un formulario que sera validado
              Form(
                key:administratorProvider.formulario,
                // Agrego los inputs
                child: Column(
                  children: [
                    InputWidget(
                      label: "Nombre Completo",
                      icono: FontAwesomeIcons.user,
                      control: nombreCompletoController,
                       validacion: (valor)=>Validations.valNombre(valor!),
                    ),
                    InputWidget(
                      label: "Usuario",
                      icono: FontAwesomeIcons.user,
                      control: usuarioController,
                      validacion: (valor)=>Validations.valCampo(valor!, "El usuario no puede ir vacio"),
                    ),
                    // Si no existe el admin se coloca el campo de cambiar constraseña o si es el dueño
                    if(widget.administrador == null || widget.administrador!.idTipo == 1)
                    InputWidget(
                      label: "Contraseña",
                      icono: FontAwesomeIcons.user,
                      control: passwordController,
                      validacion: (widget.administrador == null) ? (valor)=>Validations.valCampo(valor!, "El usuario no puede ir vacio") :null,
                      esPassword: true,
                    ),
                    DropdownButtonWidget(lista: lista(administratorProvider.listaTiposAdmins), admin: widget.administrador,),
                     if(widget.administrador == null || widget.administrador!.idTipo == 1)
                    ButtonWidget(
                        texto: (widget.esPrimeraVez)?"Registrar":(widget.administrador!=null)?" Editar" :"Agregar",
                        funcion: (){if(administratorProvider.formularioValido()) _registroAdmin(administratorProvider);},
                        esTamanoCompleto: false),
                  ],
                ),
              ),
              // Creo otra clase para no tener el codigo junto
              if (widget.administrador != null) _Ganancias(totalVentas: administratorProvider.totalVentas,totalGanancias: administratorProvider.totalGanancias)
            ],
          ),
        ),
      ),
    );
  }
  
  void _registroAdmin(AdministratorProvider provider){
    // Si el admin existe se editara al admin
    if(widget.administrador != null){
    provider.editarAdmin(widget.administrador!.idAdmin!, nombreCompletoController.text, usuarioController.text,password: (passwordController.text!="")?passwordController.text:null);
    } else{
    // Si no existe se creara
    // Defino un modelo ya que este lo ocupo para registrarlo
    AdministratorModel admin = AdministratorModel(nombre: nombreCompletoController.text, usuario: usuarioController.text, password: passwordController.text,idTipo: (widget.esPrimeraVez)? 1 : 2,bandera: 1);
    provider.registrarAdmin(admin,widget.esPrimeraVez,context);
    provider.formulario.currentState!.reset();
    }
  }
  // Esto regresara una lista para el DropdownButtonWidget
  // Recibo la lista de listaTipo para saber de cuantos tipos existen
  List<DropdownMenuItem<int>> lista(List<TypeAdminModel> listaTipo){
    List<DropdownMenuItem<int>> lista = [];
    // Se llena la lista y se retorna
    for(int i=0;i<listaTipo.length;i++){
      lista.add(DropdownMenuItem(value: listaTipo[i].idTipo,child: Text(listaTipo[i].nombre)));
    }
    return lista;
  }

}


class DropdownButtonWidget extends StatefulWidget {
  // Solicito parametros
  final AdministratorModel? admin;
  final List<DropdownMenuItem<dynamic>> lista;
  const DropdownButtonWidget({super.key,required this.lista, this.admin});

  @override
  State<DropdownButtonWidget> createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        ),
      items: widget.lista,
      // Si entra por primera vez por defecto sera el dueño
      // Si existe el admin y aparte su idTipo = 1 pondra que es el dueño
      // Si no se cumple ninguna pondra administrador
      value: (Preferences.esPrimeraVez)?1:(widget.admin!=null && widget.admin!.idTipo==1)? 1 : _opcion,
      onChanged: null,
    );
  }
}

class _Ganancias extends StatelessWidget {
  // Solicito parametros
  final int totalVentas;
  final double totalGanancias; 
  const _Ganancias({
    Key? key, required this.totalVentas, required this.totalGanancias,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Defino este estilo aqui para usarlo despues
    TextStyle titulo = const TextStyle(fontWeight: FontWeight.bold);
    // Agrego una separacion hacia arriba nomas
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      // Agrego un GridView para una separacion igual entre las columnas
      child: GridView.count(
        // Defino el tamaño de las columnas
        crossAxisCount: 2,
        // Indico que se puede dar scroll
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          // Coloco las columnas con separacion
          Column(
            children: [
              Text(
                "Total de ventas",
                style: titulo,
              ),
              const SizedBox(
                height: 10,
              ),
              Text("$totalVentas")
            ],
          ),
          Column(
            children: [
              Text(
                "Total de  ganancias",
                style: titulo,
              ),
              const SizedBox(height: 10),
              Text("\$$totalGanancias")
            ],
          ),
        ],
      ),
    );
  }
}
