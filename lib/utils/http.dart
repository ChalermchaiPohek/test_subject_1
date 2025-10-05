import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpConfig extends DioForNative {
  HttpConfig.api() {
    this
      ..options.baseUrl = "https://api-sepolia.etherscan.io/api?"
      ..options.followRedirects = false
      ..interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        compact: true,
      ));
  }
}