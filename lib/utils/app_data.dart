import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static const APP_DATA_WALLET_ADDRESS = "sp_wallet_address";
  static const APP_DATA_API_KEY = "sp_api_key";

  static final AppData singleton = AppData._internal();
  Future<SharedPreferences>? _pref;

  factory AppData() {
    return singleton;
  }

  AppData._internal() {
    _pref = SharedPreferences.getInstance();
  }

  //region Wallet address
  Future<String?> loadWalletAddress() async {
    final sharedPref = await _pref;
    sharedPref?.reload();
    return sharedPref?.getString(APP_DATA_WALLET_ADDRESS);
  }

  Future saveWalletAddress(String value) async {
    final sharedPref = await _pref;
    sharedPref?.setString(APP_DATA_WALLET_ADDRESS, value);
  }
  //endregion

  //region API Key
  Future<String?> loadAPIKey() async {
    final sharedPref = await _pref;
    sharedPref?.reload();
    return sharedPref?.getString(APP_DATA_API_KEY);
  }

  Future saveAPIKey(String value) async {
    final sharedPref = await _pref;
    sharedPref?.setString(APP_DATA_API_KEY, value);
  }
  //endregion

  Future clearAppData() async {
    final sharedPref = await _pref;
    sharedPref?.clear();
  }

}