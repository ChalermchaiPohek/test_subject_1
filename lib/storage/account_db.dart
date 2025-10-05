import 'package:test_subject_1/utils/app_data.dart';

class AccountDB {
  Future<String?> getWalletAddress() async {
    return AppData.singleton.loadWalletAddress();
  }
}