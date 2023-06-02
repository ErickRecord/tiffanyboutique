import 'package:shared_preferences/shared_preferences.dart';
// Esta clase servira para el uso de las preferencias de usuario
class Preferences {
  // Indico que se creara la variable despues
  static late SharedPreferences _prefs;

  // Indico varaibles que usare en la preferencias
  static bool _esPrimeraVez = true;
  static int _idAdmin = 0;
  static int _idTipo = 0;
  static String _nombre = "";
  static String _usuario = "";

  // Inicializo las prefencias con una promesa
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

// Genero practicamente get y set de las varialbes anteriores

 static bool get esPrimeraVez => _prefs.getBool('esPrimeraVez') ?? _esPrimeraVez;

  static set esPrimeraVez(bool esPrimeraVez) {
    _esPrimeraVez = esPrimeraVez;
    _prefs.setBool("esPrimeraVez", _esPrimeraVez);
  }

  static int get idAdmin => _prefs.getInt('idAdmin') ?? 0;

  static set idAdmin(int idAdmin) {
    _idAdmin = idAdmin;
    _prefs.setInt("idAdmin", _idAdmin);
  }

static int get idTipo => _prefs.getInt('idTipo') ?? 0;

  static set idTipo(int idTipo) {
    _idTipo = idTipo;
    _prefs.setInt("idTipo", _idTipo);
  }

  static String get nombre => _prefs.getString("nombre") ?? _nombre;

  static set nombre(String nombre) {
    _nombre = nombre;
    _prefs.setString("nombre", _nombre);
  }

  static String get usuario => _prefs.getString("usuario") ?? _usuario;

  static set usuario(String usuario) {
    _usuario = usuario;
    _prefs.setString("usuario", _usuario);
  }
}
