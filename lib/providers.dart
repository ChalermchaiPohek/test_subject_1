import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';
import 'package:test_subject_1/services/account_ws.dart';
import 'package:test_subject_1/storage/account_db.dart';
import 'package:test_subject_1/utils/http.dart';

abstract class Providers {
  static List<SingleChildWidget> getProviders() {
    return [
      Provider(create: (context) => HttpConfig.api(),),
      ProxyProvider<HttpConfig, AccountService>(
        update: (context, HttpConfig http, ret) => AccountService(http),
      ),
      Provider(create: (context) => AccountDB(),)
    ];
  }
}