import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_subject_1/bloc/wallet_main_bloc.dart';
import 'package:test_subject_1/services/account_ws.dart';
import 'package:test_subject_1/storage/account_db.dart';

class WalletMainScreen extends StatefulWidget {
  const WalletMainScreen({super.key});

  @override
  State<WalletMainScreen> createState() => _WalletMainScreenState();
}

class _WalletMainScreenState extends State<WalletMainScreen> {

  @override
  Widget build(BuildContext context) {
    return Provider<WalletMainScreenBloc>(
      create: (context) => WalletMainScreenBloc(
        Provider.of<AccountDB>(context, listen: false),
        Provider.of<AccountService>(context, listen: false),
      ),
      dispose: (context, value) => value.dispose(),
      child: Builder(
        builder: (context) {
          return _buildScreen(context);
        },
      ),
    );
  }

  Widget _buildScreen(BuildContext context) {
    final bloc = Provider.of<WalletMainScreenBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: bloc.getBalance(),
                builder: (context, snapshot) {
                  print(snapshot);
                  return Text("data");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
