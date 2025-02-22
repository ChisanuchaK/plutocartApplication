import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class TransactionRepository {
  final dio = Dio();

  Future<Map<String, dynamic>> createTransaction(
      int statementType,
      int WalletId,
      File? file,
      double stmTransaction,
      String dateTransaction,
      String? description,
      int transactionCategoryId) async {
    try {
      FormData formData;
      if (file == null) {
        formData = FormData.fromMap({
          "stmTransaction": stmTransaction,
          "statementType": statementType,
          "dateTransaction": dateTransaction,
          "description": description,
          "transactionCategoryId": transactionCategoryId,
        });
      } else {
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path),
          "stmTransaction": stmTransaction,
          "statementType": statementType,
          "dateTransaction": dateTransaction,
          "description": description,
          "transactionCategoryId": transactionCategoryId,
        });
      }
      print("form data : ${formData.fields}");
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      String? accountId = await storage.read(key: "accountId");
      int acId = int.parse(accountId!);
      print("check token : ${token}");
      print("wallet id : ${WalletId}");
      Response response = await dio.post(
        '${dotenv.env['API']}/api/account/${acId}/wallet/${WalletId}/transaction',
        data: formData,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process create transaction income in class repository: ${response.statusCode}");
      print(
          "respone data in process create transaction income class repository: ${response.data}");

      if (response.statusCode == 201 && response.data['data'] != null) {
        return response.data;
      } else {
        throw Exception(
            'Error Create Guest from login repository: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  Future<List<dynamic>> getTransactionDailyInEx() async {
    final storage = FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    int accId = int.parse(accountId!);

    try {
      String? token = await storage.read(key: "token");
      Response response = await dio.get(
          '${dotenv.env['API']}/api/account/${accId}/wallet/transaction/daily-income-and-expense',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        print(
            "retuen getTransaction dailyincome and exp : ${response.data['data']}");
        print(
            "retuen getTransaction dailyincome and exp1 : ${response.data['data'][0]['todayIncome']}");
        return response.data['data'];
      } else if (response.statusCode == 404 || response.data['data'] == null) {
        print(
            "working get transaction dailyincome and exp1 : ${response.data['data']}");
        return response.data['data'];
      } else {
        throw Exception('Unexpected error occurred: ${response.statusCode}');
      }
    } catch (error, stacktrace) {
      print("Errorw: $error - Stacktrace: $stacktrace");
      throw error;
    }
  }

  Future<List<dynamic>> getTransactionlimit3() async {
    final storage = FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    int accId = int.parse(accountId!);
    try {
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      Response response = await dio.get(
          '${dotenv.env['API']}/api/account/${accId}/transaction-limit',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        print("retuen getTransaction limit3 : ${response.data['data']}");
        return response.data['data'];
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

  Future<List<dynamic>> getTransactionByAccountId(int ? walletId , int ? month , int ? year) async {
    final storage = new FlutterSecureStorage();
    await dotenv.load();
    String? accountId = await storage.read(key: "accountId");
    int acId = int.parse(accountId!);
    try {
      String? token = await storage.read(key: "token");
      Response response = await dio.get(
        '${dotenv.env['API']}/api/account/${acId}/transaction',
        queryParameters: {"walletId" : walletId != 0 ? walletId : null , "month" : month != 0 ? month : null , "year" : year != 0 ? year : null},
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process get goal in class repository: ${response.statusCode}");
      print(
          "respone data in process get goal in class repository: ${response.data}");

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data'];
      } else {
        throw Exception(
            'Error get Transaction from trasaction repository: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  Future<Map<String, dynamic>> createTransactionGoal(
      int WalletId,
      File? file,
      double stmTransaction,
      String dateTransaction,
      String? description,
      int goalIdGoal) async {
    try {
      FormData formData;
      if (file == null) {
        formData = FormData.fromMap({
          "stmTransaction": stmTransaction,
          "statementType": 2,
          "dateTransaction": dateTransaction,
          "description": description,
          "transactionCategoryId": 32,
          "goalIdGoal": goalIdGoal
        });
      } else {
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path),
          "stmTransaction": stmTransaction,
          "statementType": 2,
          "dateTransaction": dateTransaction,
          "description": description,
          "transactionCategoryId": 32,
          "goalIdGoal": goalIdGoal
        });
      }
      print("form data : ${formData.fields}");
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      String? accountId = await storage.read(key: "accountId");
      int acId = int.parse(accountId!);
      print("check token : ${token}");
      print("wallet id : ${WalletId}");
      Response response = await dio.post(
        '${dotenv.env['API']}/api/account/${acId}/wallet/${WalletId}/transaction',
        data: formData,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process create transaction income in class repository: ${response.statusCode}");
      print(
          "respone data in process create transaction income class repository: ${response.data}");

      if (response.statusCode == 201 && response.data['data'] != null) {
        return response.data;
      } else {
        throw Exception(
            'Error Create Guest from login repository: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  Future<Map<String, dynamic>> createTransactionDebt(
      int WalletId,
      File? file,
      double stmTransaction,
      String dateTransaction,
      String? description,
      int debtIdDebt) async {
    print("create WalletId : ${WalletId}");
    print("create  repository file : ${file}");
    print("create repository stmTransaction : ${stmTransaction}");
    print("create repository description : ${description}");
    try {
      FormData formData;
      if (file == null) {
        formData = FormData.fromMap({
          "stmTransaction": stmTransaction,
          "statementType": 2,
          "dateTransaction": dateTransaction,
          "description": description,
          "transactionCategoryId": 33,
          "debtIdDebt": debtIdDebt
        });
      } else {
        formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path),
          "stmTransaction": stmTransaction,
          "statementType": 2,
          "dateTransaction": dateTransaction,
          "description": description,
          "transactionCategoryId": 33,
          "debtIdDebt": debtIdDebt
        });
      }
      print("form data : ${formData.fields}");
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      String? accountId = await storage.read(key: "accountId");
      int acId = int.parse(accountId!);
      print("check token : ${token}");
      print("wallet id : ${WalletId}");
      Response response = await dio.post(
        '${dotenv.env['API']}/api/account/${acId}/wallet/${WalletId}/transaction',
        data: formData,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process create transaction in class repository: ${response.statusCode}");
      print(
          "respone data in process create transaction  class repository: ${response.data}");

      if (response.statusCode == 201 && response.data['data'] != null) {
        return response.data;
      } else {
        throw Exception('Error Create : ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }

  Future<Map<String, dynamic>> deleteTransaction(
      int transactionId, int walletId) async {
    final storage = new FlutterSecureStorage();
    String? accountId = await storage.read(key: "accountId");
    int id = int.parse(accountId!);
    String? token = await storage.read(key: "token");
    print("id account in step deleteTransactionById : ${id}");
    try {
      Response response = await dio.delete(
          '${dotenv.env['API']}/api/account/${id}/wallet/${walletId}/transaction/${transactionId}',
          options: Options(
            headers: {
              "Authorization": 'Bearer $token',
              "${dotenv.env['HEADER_KEY']}":
                  dotenv.env['VALUE_HEADER'].toString()
            },
          ));
      if (response.statusCode == 200) {
        print("delete transaction id : ${transactionId} : success");
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

  Future<Map<String, dynamic>> updateTransactionInEx(
    int statementType,
    int transactionCategoryId,
    int walletId,
    double stmTransaction,
    String dateTimeTransaction,
    File? imageUrl,
    String? description,
    int transactionId,
  ) async {
    print("update transaction inCome repository WalletId : ${walletId}");
    print("update transaction inCome repository file : ${imageUrl}");
    print(
        "update transaction inCome repository stmTransaction : ${stmTransaction}");
    print("update transaction inCome repository description : ${description}");
    print(
        "update transaction inCome repository transactionCategoryId : ${transactionCategoryId}");
    print("statement type : ${statementType}");
    try {
      FormData formData;
      if (imageUrl == null) {
        formData = FormData.fromMap({
          "stmTransaction": stmTransaction,
          "statementType": statementType,
          "dateTransaction": dateTimeTransaction,
          "description": description,
          "transactionCategoryId": transactionCategoryId,
        });
      } else {
        print("aakims2");
        try {
          print("aakim case 1");
          http.Response response = await http.get(Uri.parse(imageUrl.path));
          print("aakim case 1  response: ${response.bodyBytes}");
          formData = FormData.fromMap({
            "file": await MultipartFile.fromBytes(
              filename: "image.jpg",
              response.bodyBytes,
              contentType: MediaType('image', 'jpg'),
            ),
            "stmTransaction": stmTransaction,
            "statementType": statementType,
            "dateTransaction": dateTimeTransaction,
            "description": description,
            "transactionCategoryId": transactionCategoryId,
          });
        } catch (Exception) {
            print("aakim case 2");
          formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(imageUrl.path),
            "stmTransaction": stmTransaction,
            "statementType": statementType,
            "dateTransaction": dateTimeTransaction,
            "description": description,
            "transactionCategoryId": transactionCategoryId,
          });
        }
      }
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      String? accountId = await storage.read(key: "accountId");
      int acId = int.parse(accountId!);
      print("check token : ${token}");
      print("wallet id : ${walletId}");
      Response response = await dio.patch(
        '${dotenv.env['API']}/api/account/${acId}/wallet/${walletId}/transaction/${transactionId}',
        data: formData,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process create transaction income in class repository: ${response.statusCode}");
      print(
          "respone data in process create transaction income class repository: ${response.data}");

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data;
      } else {
        throw Exception(
            'Error Create Guest from login repository: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }



   Future<Map<String, dynamic>> updateTransactionGoal(
    int goalId,
    int statementType,
    int transactionCategoryId,
    int walletId,
    double stmTransaction,
    String dateTimeTransaction,
    File? imageUrl,
    String? description,
    int transactionId,
  ) async {
    print("update transaction inCome repository WalletId : ${walletId}");
    print("update transaction inCome repository file : ${imageUrl}");
    print(
        "update transaction inCome repository stmTransaction : ${stmTransaction}");
    print("update transaction inCome repository description : ${description}");
    print(
        "update transaction inCome repository transactionCategoryId : ${transactionCategoryId}");
    print("statement type : ${statementType}");
    try {
      FormData formData;
      if (imageUrl == null) {
        formData = FormData.fromMap({
          "stmTransaction": stmTransaction,
          "statementType": statementType,
          "dateTransaction": dateTimeTransaction,
          "description": description,
          "transactionCategoryId": transactionCategoryId,
          "goalIdGoal" : goalId
        });
      } else {
        print("aakims2");
        try {
          print("aakim case 1");
          http.Response response = await http.get(Uri.parse(imageUrl.path));
          print("aakim case 1  response: ${response.bodyBytes}");
          formData = FormData.fromMap({
            "file": await MultipartFile.fromBytes(
              filename: "image.jpg",
              response.bodyBytes,
              contentType: MediaType('image', 'jpg'),
            ),
            "stmTransaction": stmTransaction,
            "statementType": statementType,
            "dateTransaction": dateTimeTransaction,
            "description": description,
            "transactionCategoryId": transactionCategoryId,
            "goalIdGoal" : goalId
          });
        } catch (Exception) {
            print("aakim case 2");
          formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(imageUrl.path),
            "stmTransaction": stmTransaction,
            "statementType": statementType,
            "dateTransaction": dateTimeTransaction,
            "description": description,
            "transactionCategoryId": transactionCategoryId,
            "goalIdGoal" : goalId
          });
        }
      }
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      String? accountId = await storage.read(key: "accountId");
      int acId = int.parse(accountId!);
      print("check token : ${token}");
      print("wallet id : ${walletId}");
      Response response = await dio.patch(
        '${dotenv.env['API']}/api/account/${acId}/wallet/${walletId}/transaction/${transactionId}',
        data: formData,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process create transaction income in class repository: ${response.statusCode}");
      print(
          "respone data in process create transaction income class repository: ${response.data}");

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data;
      } else {
        throw Exception(
            'Error Create Guest from login repository: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }
  


  Future<Map<String, dynamic>> updateTransactionDebt(
    int debId,
    int statementType,
    int transactionCategoryId,
    int walletId,
    double stmTransaction,
    String dateTimeTransaction,
    File? imageUrl,
    String? description,
    int transactionId,
  ) async {
    try {
      FormData formData;
      if (imageUrl == null) {
        formData = FormData.fromMap({
          "stmTransaction": stmTransaction,
          "statementType": statementType,
          "dateTransaction": dateTimeTransaction,
          "description": description,
          "transactionCategoryId": transactionCategoryId,
          "debtIdDebt" : debId
        });
      } else {
        print("aakims2");
        try {
          print("aakim case 1");
          http.Response response = await http.get(Uri.parse(imageUrl.path));
          print("aakim case 1  response: ${response.bodyBytes}");
          formData = FormData.fromMap({
            "file": await MultipartFile.fromBytes(
              filename: "image.jpg",
              response.bodyBytes,
              contentType: MediaType('image', 'jpg'),
            ),
            "stmTransaction": stmTransaction,
            "statementType": statementType,
            "dateTransaction": dateTimeTransaction,
            "description": description,
            "transactionCategoryId": transactionCategoryId,
             "debtIdDebt" : debId
          });
        } catch (Exception) {
            print("aakim case 2");
          formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(imageUrl.path),
            "stmTransaction": stmTransaction,
            "statementType": statementType,
            "dateTransaction": dateTimeTransaction,
            "description": description,
            "transactionCategoryId": transactionCategoryId,
             "debtIdDebt" : debId
          });
        }
      }
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: "token");
      String? accountId = await storage.read(key: "accountId");
      int acId = int.parse(accountId!);
      print("check token : ${token}");
      print("wallet id : ${walletId}");
      Response response = await dio.patch(
        '${dotenv.env['API']}/api/account/${acId}/wallet/${walletId}/transaction/${transactionId}',
        data: formData,
        options: Options(
          headers: {
            "Authorization": 'Bearer $token',
            "${dotenv.env['HEADER_KEY']}": dotenv.env['VALUE_HEADER'].toString()
          },
        ),
      );
      print(
          "respone code in process create transaction income in class repository: ${response.statusCode}");
      print(
          "respone data in process create transaction income class repository: ${response.data}");

      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data;
      } else {
        throw Exception(
            'Error Create Guest from login repository: ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw error;
    }
  }
}
