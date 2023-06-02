import 'package:sqflite/sqflite.dart';
import 'package:tiffanyapp/src/models/administrator_model.dart';
import 'package:tiffanyapp/src/models/categories_model.dart';
import 'package:tiffanyapp/src/models/clothes_model.dart';
import 'package:tiffanyapp/src/models/sales_details_model.dart';
import 'package:tiffanyapp/src/models/sales_model.dart';
import 'package:tiffanyapp/src/models/types_admins_model.dart';

class DB {
  // Creo la variable de la base de datos
  static Database? _db;

  // Este metodo se ejecutara al inicio
  static Future<Database> init() async {
    // Creo la base de datos con el nombre tiffany.db
    return _db = await openDatabase(
      "tiffany.db",
      // Inico la version
      version: 1,
      // El onCreate sirve para ejecutar el codigo sqlite al instalar la aplicacion por primera vez
      onCreate: (db, version) async => {
        await db.execute('''
        CREATE TABLE Tipo_Admins(
          idTipo INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL
        );
        '''),

        await db.execute("INSERT INTO Tipo_Admins (nombre) VALUES ('Dueño');"),
        await db.execute("INSERT INTO Tipo_Admins (nombre) VALUES ('Administrador');"),
        
        await db.execute('''
        CREATE TABLE Administradores(
          idAdmin INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL,
          usuario TEXT NOT NULL,
          password TEXT NOT NULL,
          idTipo INTEGER NOT NULL,
          bandera INTEGER NOT NULL,
          FOREIGN KEY(idTipo) REFERENCES Tipo_Admins(idTipo)
        );
        '''),

        await db.execute('''
        CREATE TABLE Categorias(
          idCategoria INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT NOT NULL
        );
        '''),

        await db.execute("INSERT INTO Categorias (nombre) VALUES ('Blusas');"),
        await db.execute("INSERT INTO Categorias (nombre) VALUES ('Pantalones');"),
        await db.execute("INSERT INTO Categorias (nombre) VALUES ('Faldas');"),
        await db.execute("INSERT INTO Categorias (nombre) VALUES ('Vestidos');"),
        await db.execute("INSERT INTO Categorias (nombre) VALUES ('Bolsos');"),

        await db.execute('''
        CREATE TABLE Prendas(
          idPrenda INTEGER PRIMARY KEY AUTOINCREMENT,
          imagen BLOB NOT NULL,
          codigo TEXT NOT NULL,
          nombre TEXT NOT NULL,
          existencia INTEGER NOT NULL,
          precio REAL NOT NULL,
          color TEXT NOT NULL,
          idCategoria INTEGER NOT NULL,
          bandera INTEGER NOT NULL,
          FOREIGN KEY(idCategoria) REFERENCES Categorias(idCategoria)
        );
        '''),

        await db.execute('''
        CREATE TABLE Ventas(
          idVenta INTEGER PRIMARY KEY AUTOINCREMENT,
          idAdmin INTEGER NOT NULL,
          total REAL NOT NULL,
          fecha NUMERIC NOT NULL,
          FOREIGN KEY(idAdmin) REFERENCES Administradores(idAdmin)
        );
        '''),

        await db.execute('''
        CREATE TABLE DetallesVentas(
          idDetallesVentas INTEGER PRIMARY KEY AUTOINCREMENT,
          idVenta INTEGER NOT NULL,
          idPrenda DATE NOT NULL,
          cantidad INTEGER NOT NULL,
          total REAL NOT NULL,
          FOREIGN KEY(idVenta) REFERENCES Ventas(idVenta),
          FOREIGN KEY(idPrenda) REFERENCES Prendas(idPrenda)
        );
        '''),
      },
    );
  }

  static Future<List<TypeAdminModel>> consultarTipos()async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT idTipo, nombre FROM Tipo_Admins");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => TypeAdminModel.fromMap(e)).toList();
  }

  // Los metodos los creo estaticos para consultarlos sin instanciarlos
  // Este metodo regresa un entero el cual seria su id
  static Future<int> registrarAdmin(AdministratorModel administrador)async{
    // Llamo al metodo inicial
    await init();
    // Le indico a que tabla le mandare el mapeo
    return _db!.insert("Administradores", administrador.toMap());
  }
  // Este metodo regresa una lista de administradores
  static Future<List<AdministratorModel>> consultarAdmins(int pagina)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT idAdmin, ad.nombre, usuario, password, ad.idTipo AS idTipo, ta.nombre AS tipo, bandera FROM Administradores ad INNER JOIN Tipo_Admins ta ON ad.idTipo = ta.idTipo WHERE bandera = 1 ORDER BY ad.idTipo ASC, idAdmin DESC LIMIT ${(pagina * 10)},10");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => AdministratorModel.fromMap(e)).toList();
  }

  // Este metodo regresa una lista de administradores
  static Future<List<AdministratorModel>> consultarAdmin(String usuario, String password)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT idAdmin, ad.nombre, usuario, password, ad.idTipo AS idTipo, ta.nombre AS tipo, bandera FROM Administradores ad INNER JOIN Tipo_Admins ta ON ad.idTipo = ta.idTipo WHERE bandera = 1 AND usuario = '$usuario' AND password = '$password' LIMIT 1");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => AdministratorModel.fromMap(e)).toList();
  }

   static Future<List<SalesModel>> consultarGananciasAdmin(int idAdmin)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT COUNT(idVenta) as totalVentas, SUM(total) as total FROM Ventas WHERE idAdmin = $idAdmin");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => SalesModel.fromMapAdmin(e)).toList();
  }

    // Este metodo elimina a un administrador
  static Future<int> eliminarAdmin(int idAdmin)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawUpdate("UPDATE Administradores SET bandera = 0 WHERE idAdmin = $idAdmin;");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res;
  }
// En esta ocacion solicito un parametro opcional el cual es la password
// Si esta es nula no se cambio y si no es nula cambia la password
static Future<int> editarAdmin(int idAdmin, String nombre, String usuario, {String? password})async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawUpdate("UPDATE Administradores SET nombre = '$nombre', usuario = '$usuario' ${(password!=null)? ", password = '$password'":""} WHERE idAdmin = $idAdmin;");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res;
  }

    static Future<List<CategoriesModel>> consultarCategorias()async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT idCategoria, nombre FROM Categorias");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => CategoriesModel.fromMap(e)).toList();
  }

 static Future<int> registrarPrenda(ClothesModel prenda)async{
    // Llamo al metodo inicial
    await init();
    // Le indico a que tabla le mandare el mapeo
    return _db!.insert("Prendas", prenda.toMap());
  }

    // Este metodo regresa elimina a un administrador
  static Future<int> eliminarPrenda(int idPrenda)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawUpdate("UPDATE Prendas SET bandera = 0 WHERE idPrenda = $idPrenda");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res;
  }

static Future<List<ClothesModel>> consultarPrendas(int pagina, {int? idCategoria = 0, String? color = "", String codigo = "", String nombre = ""})async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    String sql = "SELECT idPrenda, imagen, codigo, pr.nombre, existencia, precio, color, pr.idCategoria, ca.nombre AS categoria, bandera FROM Prendas pr JOIN Categorias ca ON pr.idCategoria = ca.idCategoria ";
    String concatenar = "";
    if(idCategoria != 0){
      concatenar += "pr.idCategoria = $idCategoria ";
    }
    if(color != ""){
    if(concatenar != "") concatenar += "AND ";
      concatenar += "color LIKE  '%$color%' ";
    }
    if(codigo != ""){
    if(concatenar != "") concatenar += "AND ";
      concatenar += "codigo LIKE  '%$codigo%' ";
    }
    if(nombre != ""){
    if(concatenar != "") concatenar += "AND ";
      concatenar += "pr.nombre LIKE  '%$nombre%' ";
    }
    if(concatenar != ""){
      sql += "WHERE bandera = 1 AND $concatenar ";
    } else{
      sql += "WHERE bandera = 1 ";
    }
    sql += "ORDER BY idPrenda DESC LIMIT ${pagina * 5},5";
    final res = await _db!.rawQuery(sql);
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => ClothesModel.fromMap(e)).toList();
  }


static Future<int> editarPrenda(ClothesModel prenda)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.update("Prendas",prenda.toMap(),where: "idPrenda = ?", whereArgs: [prenda.idPrenda]);
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res;
  }

  static Future<int> registrarVenta(SalesModel venta)async{
    // Llamo al metodo inicial
    await init();
    // Le indico a que tabla le mandare el mapeo
    return _db!.insert("Ventas", venta.toMap());
  }

  static Future<int> registrarDetalleVenta(SalesDetailsModel detallesVentas)async{
    // Llamo al metodo inicial
    await init();
    // Le indico a que tabla le mandare el mapeo
    return _db!.insert("DetallesVentas", detallesVentas.toMap());
  }

    static Future<List<SalesDetailsModel>> consultarVentas(String fechaInicial, String fechaFinal)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT v.idVenta, v.total, a.usuario,fecha, SUM(dv.cantidad) AS cantidad, dv.total AS totalPrenda FROM DetallesVentas dv JOIN Ventas v ON dv.idVenta = v.idVenta JOIN Administradores a ON v.idAdmin = a.idAdmin WHERE fecha BETWEEN '$fechaInicial' AND '$fechaFinal' GROUP BY v.idVenta ORDER BY idDetallesVentas DESC");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => SalesDetailsModel.fromMap(e)).toList();
  }

static Future<List<SalesModel>> consultarTotalPrendas()async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT COUNT(idPrenda) AS total FROM Prendas WHERE bandera = 1");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => SalesModel.fromMap(e)).toList();
  }

static Future<List<SalesModel>> consultarTotal(String fechaInicial, String fechaFinal)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawQuery("SELECT SUM(total) AS total FROM Ventas WHERE fecha BETWEEN '$fechaInicial' AND '$fechaFinal'");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res.map((e) => SalesModel.fromMap(e)).toList();
  }

static Future<int> editarExistencia(int idPrenda, int cantidad)async{
    // Llamo al metodo inicial
    await init();
    // Indico la consulta
    final res = await _db!.rawUpdate("UPDATE Prendas SET existencia = existencia - $cantidad WHERE idPrenda = $idPrenda;");
    // El resultado lo mapeo para asi mandarlo al modelo y lo convierto en una lista
    return res;
  }

}
