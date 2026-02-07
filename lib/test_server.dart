import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  await startDebugServer();
}

Future<void> startDebugServer() async {
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler((Request request) {
    if (request.url.path == 'test') {
      return Response.ok(
        '{"status": "ok", "msg": "DB reachable"}',
        headers: {'Content-Type': 'application/json'},
      );
    }
    return Response.notFound('Not Found');
  });

  // شغّل السيرفر على أي واجهة
  final server = await io.serve(handler, InternetAddress.anyIPv4, 8080);
  print(
      '✅ Debug server running on http://${server.address.host}:${server.port}');
}
