import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:test_subject_1/model/balance_model.dart';
import 'package:test_subject_1/model/transaction_model.dart';
import 'package:test_subject_1/utils/app_data.dart';

class AccountService {
  final DioMixin http;

  AccountService(this.http);

  Future<Balance> getWalletBalance({String? address, CancelToken? cancelToken}) async {
    final String? walletAddress = await AppData.singleton.loadWalletAddress();
    final String? apiKey = await AppData.singleton.loadAPIKey();
    final Map<String, dynamic> queryParams = {
      "module": "account",
      "action": "balance",
      "address": (address != null && address != walletAddress) ? address : walletAddress,
      "tag": "latest",
      "apikey": apiKey
    };
    return http.get("", queryParameters: queryParams).then((value) {
      if (value.statusCode != 200) {
        throw Error.throwWithStackTrace(value.statusMessage.toString(), StackTrace.current);
      }
      final resp = value.data;
      return Balance.fromJson(resp);
    },);
  }

  Future<List<Transaction>> getTransaction({int? page, int? offset}) async {
    final String? walletAddress = await AppData.singleton.loadWalletAddress();
    final String? apiKey = await AppData.singleton.loadAPIKey();
    final Map<String, dynamic> queryParams = {
      "module": "account",
      "action": "txlist",
      "address": walletAddress,
      "startblock": 0,
      "endblock": 99999999,
      "page": page ?? 1,
      "offset": offset ?? 20,
      "sort": "asc",
      "apikey": apiKey
    };

    return http.get("", queryParameters: queryParams).then((value) {
      if (value.statusCode != 200) {
        throw Error.throwWithStackTrace(value.statusMessage.toString(), StackTrace.current);
      }
      final resp = value.data;
      final rawValue = resp["result"];
      if (rawValue is String) {
        throw Error.throwWithStackTrace(rawValue, StackTrace.current);
      }
      return List<Transaction>.from(resp["result"].map((x) => Transaction.fromJson(x)));
    },);
  }

}