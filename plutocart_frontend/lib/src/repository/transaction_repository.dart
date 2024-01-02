import 'dart:io';

import 'package:dio/dio.dart';
import 'package:plutocart/src/models/wallet/wallet_model.dart';

class TransactionRepository {
final dio = Dio();

  Future<Wallet> getTransactionAll(int id) async {

    try {
      Response response = await dio.get('https://capstone23.sit.kmutt.ac.th/ej1/api/account/${id}/wallet/1');
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
Future<Map<String, dynamic>> createTransactionInCome(int WalletId , File? file , double stmTransaction , String? description , int transactionCategoryId) async {
  print("create transaction inCome repository WalletId : ${WalletId}");
  print("create transaction inCome repository file : ${file}");
  print("create transaction inCome repository stmTransaction : ${stmTransaction}");
  print("create transaction inCome repository description : ${description}");
  print("create transaction inCome repository transactionCategoryId : ${transactionCategoryId}");
    try {
       FormData formData = FormData.fromMap({
      "file": file == null ? "" : await MultipartFile.fromFile(file!.path),
      "stmTransaction": stmTransaction,
      "statementType": 1,
      "description": description,
      "transactionCategoryId": transactionCategoryId,
    });
      Response response = await dio.post(
        'https://capstone23.sit.kmutt.ac.th/ej1/api/wallet/${WalletId}/transaction',
        data: formData,
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
}