import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/single_child_widget.dart';
import 'package:test_subject_1/providers.dart';
import 'package:provider/provider.dart';
import 'package:test_subject_1/storage/account_db.dart';
import 'package:test_subject_1/ui/wallet_main_screen.dart';
import 'package:test_subject_1/utils/app_data.dart';

class MyApp extends StatefulWidget {
  final String? buildFlavor;
  const MyApp({super.key, this.buildFlavor});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<SingleChildWidget> providers = Providers.getProviders();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) {
          return FutureBuilder(
            future: Future.wait([
              Provider.of<AccountDB>(context).getWalletAddress().then((value) async {
                if (value == null || value == "") {
                  final String response = await rootBundle.loadString("assets/env/${widget.buildFlavor}_env.json");
                  final data = jsonDecode(response);
                  await AppData.singleton.saveWalletAddress(data["wallet_address"] ?? "");
                  await AppData.singleton.saveAPIKey(data["api_key"] ?? "");
                  return value;
                }
              },),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    /// TODO: add fancy loading animation
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            snapshot.error.toString(),
                            textDirection: TextDirection.ltr,
                            style: Theme.of(context).textTheme.titleLarge!.apply(color: Colors.red),
                          ),
                        ),
                      ),
                    )
                );
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: WalletMainScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
