import 'dart:io';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpConfig extends DioForNative {
  HttpConfig.api() { // Config config, {bool ignoredClientError = false}
    Map<String, dynamic> headers = <String, dynamic>{};
    // if (config.userAgent != null) {
    //   headers[HttpHeaders.userAgentHeader] = config.userAgent;
    // }

    // this._configure();
    this
      ..options.baseUrl = "https://api-sepolia.etherscan.io/api?"
      ..options.followRedirects = false
      // ..options.headers = headers
      // ..options.validateStatus = (status) {
      //   return status == 401 || (ignoredClientError ? (status != null && status < 500) : (status != null && status < 400));
      // }
    /// TODO: recheck interceptor
      // ..interceptors.add(BasicHttpInterceptor())
      // ..interceptors.add(RedirectInterceptor(this))
      // ..interceptors.add(AuthInterceptor(this))
      ..interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: false,
        responseBody: false,
        responseHeader: false,
        compact: true,
      ));
  }

  // HttpConfig.basic(
  //     Config config,
  //     {
  //       Duration? connectTimeout,
  //       Duration? receiveTimeout,
  //       bool ignoredClientError = false
  //     }) {
  //   Map<String, dynamic> headers = <String, dynamic>{};
  //   if (config.userAgent != null) {
  //     headers[HttpHeaders.userAgentHeader] = config.userAgent;
  //   }
  //   headers["X-FI-App-Code"] = config.appCode?.code ?? "UNDEFINED";
  //   this._configure();
  //   this
  //     ..options.connectTimeout = connectTimeout != null ? connectTimeout : Duration(milliseconds: 30000)
  //     ..options.receiveTimeout = receiveTimeout != null ? receiveTimeout : Duration(milliseconds: 30000)
  //     ..options.followRedirects = false
  //     ..options.headers = headers
  //     ..options.validateStatus = (status) {
  //       return ignoredClientError
  //           ? (status != null && status < 500)
  //           : ((status != null && status < 400) || status == 401);
  //     }
  //     ..interceptors.add(BasicHttpInterceptor())
  //     ..interceptors.add(RedirectInterceptor(this))
  //     ..interceptors.add(PrettyDioLogger(
  //       requestHeader: false,
  //       requestBody: false,
  //       responseBody: false,
  //       responseHeader: false,
  //       compact: true,
  //     ));
  // }
  //
  // _configure() {
  //   (this.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
  //       (HttpClient client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //     return client;
  //   };
  // }
  //
  // HttpConfig() {
  //   this._configure();
  // }
}