import 'package:postgres/postgres.dart';

class DBProvider {

  static Future<Connection> getConnection() async {
    final conn = Connection.open(Endpoint(
        host: '10.0.2.2',
        database: 'Voita',
        username: 'postgres',
        password: 'p7s8t3h2c46',
      ),

      settings: const ConnectionSettings(sslMode: SslMode.disable)
      );

    return await conn;
  }

}