import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:test_subject_1/model/balance_model.dart';
import 'package:test_subject_1/model/transaction_model.dart';
import 'package:test_subject_1/services/account_ws.dart';
import 'package:test_subject_1/storage/account_db.dart';
import 'package:test_subject_1/utils/app_data.dart';

class WalletMainScreenBloc {
  final AccountDB _accountDB;
  final AccountService _accountService;

  late BehaviorSubject<bool> _toggleFullAddress;
  Stream<bool> get toggleFullAddressStrm => _toggleFullAddress.stream;

  WalletMainScreenBloc(this._accountDB, this._accountService) {
    _toggleFullAddress = BehaviorSubject<bool>.seeded(false);
  }

  String? walletAddress;

  void dispose() {
    _toggleFullAddress.close();
  }

  Future<Balance> getBalance() async {
    walletAddress = await AppData.singleton.loadWalletAddress();
    final resp = await _accountService.getWalletBalance();
    return resp;
  }

  Future<Transaction?> getTransactions() async {
    final Transaction? transactions = await _accountService.getTransaction(offset: 50);
    if (transactions == null || transactions.result == null) {
      return null;
    }

    transactions.result!.sort((a, b) {
      if (a.timeStamp == null && b.timeStamp != null) {
        return 1;
      }
      if (a.timeStamp != null && b.timeStamp == null) {
        return -1;
      }
      if (a.timeStamp == null && b.timeStamp == null) {
        return 0;
      }

      return a.timeStamp!.compareTo(b.timeStamp!);
    },);

    return transactions;
  }
}