import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';
import 'package:image/image.dart';
import 'package:barcode_image/barcode_image.dart';

@CloudFunction()
Response function(Request request) {
  final params = request.url.queryParameters;
  final data = params['d'];

  if (data == null || data.isEmpty) {
    return Response(405,
        body:
            'Please set the `d`(data) param, including `w`(width) and/or `h`(height)',
        headers: {
          'content-type': 'text/plain',
        });
  }
  final width = int.tryParse(params['w'] ?? '') ?? 150;
  final height = int.tryParse(params['h'] ?? '') ?? 150;

  final image = Image(width, height);

  fill(image, getColor(255, 255, 255));

  drawBarcode(image, Barcode.qrCode(), params['d']);

  return Response.ok(encodePng(image), headers: {
    'content-type': 'image/png',
  });
}
