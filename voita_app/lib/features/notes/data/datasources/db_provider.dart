import 'dart:io';

import 'package:postgres/postgres.dart';

class DBProvider {

  Future<Connection> connection() {
    final conn = Connection.open(Endpoint(
        host: '10.0.2.2',
        database: 'Voita',
        username: 'postgres',
        password: 'p7s8t3h2c46',
      ),

      settings: ConnectionSettings(sslMode: SslMode.disable)
      );

    return conn;
  }

}