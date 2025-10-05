import 'package:dio/dio.dart';
import 'package:test_subject_1/utils/app_data.dart';

class AccountService {
  final DioMixin http;

  AccountService(this.http);

  Future getWalletBalance({CancelToken? cancelToken}) async {
    final String? walletAddress = await AppData.singleton.loadWalletAddress();
    final String? apiKey = await AppData.singleton.loadAPIKey();
    final Map<String, dynamic> queryParams = {
      "module": "account",
      "action": "balance",
      "address": walletAddress,
      "tag": "latest",
      "apikey": apiKey
    };
//https://api-sepolia.etherscan.io/api?module=account&action=balance&address=0x382b4ca2c4a7cd28c1c400c69d81ec2b2637f7dd&tag=latest&apikey=YourApiKeyToken
    return http.get("", queryParameters: queryParams);
  }


}