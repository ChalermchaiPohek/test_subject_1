import 'dart:convert';

Balance balanceFromJson(String str) => Balance.fromJson(json.decode(str));

String balanceToJson(Balance data) => json.encode(data.toJson());

class Balance {
  final String? status;
  final String? message;
  final String? result;

  Balance({
    this.status,
    this.message,
    this.result,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
    status: json["status"],
    message: json["message"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": result,
  };
}
