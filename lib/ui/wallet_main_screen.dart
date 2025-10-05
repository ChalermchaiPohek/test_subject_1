import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:test_subject_1/bloc/wallet_main_bloc.dart';
import 'package:test_subject_1/common/currency_unit.dart';
import 'package:test_subject_1/model/balance_model.dart';
import 'package:test_subject_1/model/transaction_model.dart';
import 'package:test_subject_1/services/account_ws.dart';
import 'package:test_subject_1/storage/account_db.dart';
import 'package:test_subject_1/utils/app_data.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class WalletMainScreen extends StatefulWidget {
  const WalletMainScreen({super.key});

  @override
  State<WalletMainScreen> createState() => _WalletMainScreenState();
}

class _WalletMainScreenState extends State<WalletMainScreen> {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 4,
  );

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
        child: Column(
          children: [
            FutureBuilder<Balance>(
              future: bloc.getBalance(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRowChildren(
                          context,
                          Text("Wallet address: "),
                          Text("N/A"),
                        ),
                        _buildRowChildren(
                          context,
                          Text("Balance:"),
                          Text("N/A"),
                        ),
                      ],
                    ),
                  );
                }

                final Balance? data = snapshot.data;
                final BigInt? wei = BigInt.tryParse(data?.result ?? "");
                return Skeletonizer(
                  enabled: snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRowChildren(
                          context,
                          Text("Wallet address: "),
                          Text(shortenAddress(bloc.walletAddress ?? ""), overflow: TextOverflow.fade, maxLines: 1, softWrap: false,),
                        ),
                        _buildRowChildren(
                            context,
                            Text("Balance:"),
                            Text(formatCurrency(CurrencyUnit.toUSD(wei ?? BigInt.zero)))
                        ),
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
                  _buildErrorWidget(context, errorText: snapshot.error.toString());
                }

                final isLoading = snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState != ConnectionState.done;
                if (isLoading) {
                  return Center(
                    child: LottieBuilder.asset(
                      "assets/lotties/loading.json",
                      width: 200,
                      height: 200,
                    ),
                  );
                }

                final transactionList = snapshot.data?.result ?? [];
                if (transactionList.isEmpty && snapshot.connectionState == ConnectionState.active) {
                  return _buildErrorWidget(context, errorText: "Data not found.");
                }

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      bloc.refreshData(null);
                    },
                    child: StreamBuilder(
                      stream: bloc.toggleReload,
                      builder: (context, event) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: transactionList.length,
                          itemBuilder: (context, index) {
                            final transaction = transactionList.elementAt(index);
                            final BigInt? wei = BigInt.tryParse(transaction.value ?? "");
                            return ListTile(
                              onTap: () {
                                return _showDetailDialog(context, transaction);
                              },
                              title: Text("${shortenAddress(transaction.from ?? "")} -> ${shortenAddress(transaction.to ?? "")}"),
                              subtitle: Text("Transfer value: ${formatCurrency(CurrencyUnit.toUSD(wei ?? BigInt.zero))}"),
                              trailing: GestureDetector(
                                onTap: () {
                                  return _showDetailDialog(context, transaction);
                                },
                                child: Icon(CupertinoIcons.info_circle),
                              ),
                            );
                          },
                        );
                      },
                    )
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Result transaction) {
    final bloc = Provider.of<WalletMainScreenBloc>(context, listen: false);
    final DateTime timestamp = fromUnix(int.tryParse(transaction.timeStamp ?? "") ?? 0);
    final String? contactAddress = bloc.walletAddress == transaction.to ? transaction.from : transaction.to;
    showDialog(context: context, builder: (dialogCtx) {
      return Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRowChildren(
                context,
                Text("Block # "),
                Text(transaction.blockNumber ?? ""),
              ),
              _buildRowChildren(
                context,
                Text("Timestamp: "),
                Text(timestamp.toIso8601String()),
              ),
              _buildRowChildren(
                context,
                Text("Contact Address: "),
                Text(shortenAddress(contactAddress ?? "")),
              ),
              FutureBuilder<Balance>(
                future: bloc.getBalance(address: contactAddress),
                builder: (_, ss) {
                  final Balance? data = ss.data;
                  final BigInt? wei = BigInt.tryParse(data?.result ?? "");

                  return _buildRowChildren(
                    context,
                    Text("Contact Address Balance: "),
                    Text(formatCurrency(CurrencyUnit.toUSD(wei ?? BigInt.zero))),
                  );
                },
              )
            ],
          ),
        ),
      );
    },);
  }

  Widget _buildRowChildren(BuildContext context, Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildErrorWidget(BuildContext context, {String? errorText}) {
    return Column(
      children: [
        Center(
          child: LottieBuilder.asset(
            "assets/lotties/not_found.json",
            width: 200,
            height: 200,
          ),
        ),
        errorText == null ? const SizedBox() : Text(errorText)
      ],
    );
  }

  String shortenAddress(String text, {int prefix = 6, int suffix = 4}) {
    if (text.length <= prefix + suffix) return text;
    return '${text.substring(0, prefix)}...${text.substring(text.length - suffix)}';
  }

  String formatCurrency(double amount) {
    return currencyFormatter.format(amount);
  }

  DateTime fromUnix(int timestamp) {
    // Detect if timestamp is in seconds or milliseconds
    if (timestamp.toString().length == 10) {
      // Unix timestamp in seconds
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else if (timestamp.toString().length == 13) {
      // Unix timestamp in milliseconds
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else {
      throw ArgumentError('Invalid timestamp length: $timestamp');
    }
  }
}
