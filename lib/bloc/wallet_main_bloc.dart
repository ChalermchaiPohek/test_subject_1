import 'package:test_subject_1/services/account_ws.dart';
import 'package:test_subject_1/storage/account_db.dart';

class WalletMainScreenBloc {
  final AccountDB _accountDB;
  final AccountService _accountService;

  WalletMainScreenBloc(this._accountDB, this._accountService);

  void dispose() {}

  Future getBalance() async {
    return _accountService.getWalletBalance();
  }
}