import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_subject_1/bloc/wallet_main_bloc.dart';
import 'package:test_subject_1/common/currency_unit.dart';
import 'package:test_subject_1/model/balance_model.dart';
import 'package:test_subject_1/services/account_ws.dart';
import 'package:test_subject_1/storage/account_db.dart';
import 'package:test_subject_1/utils/app_data.dart';

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
              FutureBuilder<Balance>(
                future: bloc.getBalance(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    /// TODO: handling error.
                  }

                  final Balance? data = snapshot.data;
                  final BigInt? wei = BigInt.tryParse(data?.result ?? "");
                  // final double? eth = CurrencyUnit.ether.fromWei(wei ?? BigInt.zero);
                  return Skeletonizer(
                    enabled: snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.amberAccent
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text("Wallet address: ")),
                              Expanded(child: Text(shortenAddress(bloc.walletAddress ?? ""), overflow: TextOverflow.fade, maxLines: 1, softWrap: false,)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Balance:"),
                              Text("\$${CurrencyUnit.toUSD(wei ?? BigInt.zero).toStringAsFixed(4)}") /// TODO: add numberformat
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              FutureBuilder(
                future: bloc.getTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    /// TODO: handling error.
                  }

                  final isLoading = snapshot.connectionState == ConnectionState.waiting;
                  final transactionList = snapshot.data?.result ?? [];

                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: transactionList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final transaction = transactionList.elementAt(index);
                        final BigInt? wei = BigInt.tryParse(transaction.value ?? "");
                        
                        return ListTile(
                          onTap: () {

                          },
                          title: Text("${shortenAddress(transaction.from ?? "")} -> ${shortenAddress(transaction.to ?? "")}"),
                          subtitle: Text("\$${CurrencyUnit.toUSD(wei ?? BigInt.zero).toStringAsFixed(4)}"),
                          trailing: GestureDetector(
                            onTap: () {
                              /// TODO: show more detail.
                            },
                            child: Icon(CupertinoIcons.info_circle),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }


  String shortenAddress(String text, {int prefix = 6, int suffix = 4}) {
    if (text.length <= prefix + suffix) return text;
    return '${text.substring(0, prefix)}...${text.substring(text.length - suffix)}';
  }
}
