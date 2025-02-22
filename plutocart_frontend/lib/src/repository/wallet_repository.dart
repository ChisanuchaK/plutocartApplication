import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plutocart/src/models/wallet/wallet_model.dart';

class walletRepository {
  final dio = Dio();

  Future createWallet(String walletName, double walletBalance) async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    print("iddd : ${id}");
    try {
      Map<String, dynamic> requestBody = {
        "walletName": walletName,
        "walletBalance": walletBalance,
      };

      Response response = await dio.post(
          '${dotenv.env['API']}/api/account/${id}/wallet',
          data: requestBody,
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 201) {
        print("create successfully");
        return response.data;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future deleteWalletById(int walletId) async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    try {
      Response response = await dio.delete(
          '${dotenv.env['API']}/api/account/${id}/wallet/${walletId}',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        log(1);
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future<dynamic> updateWallet(
      int walletId, String walletName, double balanceWallet) async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    try {
      Response response = await dio.patch(
          '${dotenv.env['API']}/api/account/$id/wallet/$walletId/wallet-name',
          queryParameters: {
            'wallet-name': walletName,
            'balance-wallet': balanceWallet,
          },
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        Wallet wallet = Wallet(
            walletId: walletId,
            walletName: walletName,
            walletBalance: balanceWallet);
        return wallet;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future<Wallet> updateStatusWallet(int walletId) async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    try {
      Response response = await dio.patch(
          '${dotenv.env['API']}/api/account/$id/wallet/$walletId/wallet-status',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        Wallet wallet =
            Wallet(walletId: walletId, walletName: "", walletBalance: 0.0);
        return wallet;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future<dynamic> getWalletAll() async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    try {
      Response response = await dio.get(
          '${dotenv.env['API']}/api/account/${id}/wallet',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        List<dynamic> wallets = response.data!;
        return wallets;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future<dynamic> getWalletAllStatusOn() async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    try {
      Response response = await dio.get(
          '${dotenv.env['API']}/api/account/${id}/wallet/status-on',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        List<dynamic> wallets = response.data!;
        return wallets;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future<Wallet> getWalletById(int walletId) async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    String? token = await storage.read(key: "token");
    int id = int.parse(accountId!);
    try {
      Response response = await dio.get(
          '${dotenv.env['API']}/api/account/${id}/wallet/${walletId}',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        Wallet responseData = Wallet.fromJson(response.data);
        return responseData;
      } else if (response.statusCode == 404) {
        throw Exception('Resource not found');
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Error: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }
}
