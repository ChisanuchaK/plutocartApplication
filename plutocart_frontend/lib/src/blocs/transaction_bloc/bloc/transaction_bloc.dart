import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plutocart/src/blocs/debt_bloc/debt_bloc.dart';
import 'package:plutocart/src/repository/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionState()) {
    on<ResetTransactionStatus>((event, emit) async {
      emit(state.copyWith(
          incomeStatus: TransactionStatus.loading, stmTransaction: 0.0));
    });

        on<ResetTransactionGoalStatus>((event, emit) async {
      emit(state.copyWith(
          goalStatus: TransactionStatus.loading, stmTransaction: 0.0 , debtStatus: TransactionStatus.loading));
    });

  on<ResetTransactionDebtStatus>((event, emit) async {
      emit(state.copyWith(
          debtStatus: TransactionStatus.loading));
    });


     on<ResetUpdateTransactionInEx>((event, emit) async {
      emit(state.copyWith(
          updateTransactionInEx: TransactionStatus.loading));
    });
     on<ResetUpdateTransactionGoal>((event, emit) async {
      emit(state.copyWith(
          updateTransactionGoal: TransactionStatus.loading));
    });
     on<ResetUpdateTransactionDebt>((event, emit) async {
      emit(state.copyWith(
          updateTransactionDebt: TransactionStatus.loading));
    });
    
         on<StatusLoadTransactionList>((event, emit) async {
      emit(state.copyWith(
          getTransactionStatus: TransactionStatus.loading));
    });
    

 on<ResetTransactionList>((event, emit) async {
      emit(state.copyWith(
          transactionList: []));
    });
    on<ResetTransaction>((event, emit) {
      emit(TransactionState()); // Reset the state to the initial state
    });

    on<GetTransactionDailyInEx>(
      (event, emit) async {
        List<dynamic> response =
            await TransactionRepository().getTransactionDailyInEx();
        print("Start get transaction daily in ex");
        try {
          if (response.length > 0 && response.isNotEmpty) {
            emit(state.copyWith(transactionsDailyInExList: response));
            print(
                "state.transactionsDailyInExList : ${state.transactionsDailyInExList}");
          }
        } catch (e) {
          print("Error state.transactionsDailyInExList");
        }
      },
    );

      on<UpdateFilterStatus>(
      (event, emit) async {
          emit(state.copyWith(filterWalletId: event.walletId , filterMonth : event.month ,  filterYear: event.year)); 
      },
    );

    on<GetTransactionLimit3>(
      (event, emit) async {
        List<dynamic> response =
            await TransactionRepository().getTransactionlimit3();
        print("Start get transaction limit 3");
        try {
          emit(state.copyWith(transactionLimit3: response));
          print(
              "state.transactionsLimit3 : ${state.transactionLimit3[0].walletName}");
        } catch (e) {
          print("Error state.transactionsLimit3");
        }
      },
    );

        on<GetTransactionList>(
      (event, emit) async {
        List<dynamic> response =
            await TransactionRepository().getTransactionByAccountId(event.walletId != null ? event.walletId : null , event.month !=null ? event.month : null , event.year != null ? event.year : null ,);
            print(event.walletId);
        print("Start get transaction by account id");
        try {
          emit(state.copyWith(transactionList: response , getTransactionStatus : TransactionStatus.loaded));
          print(
              "state.transactionsList : ${state.transactionList[0]}");
        } catch (e) {
          print("Error state.transactionList");
        }
      },
    );


    on<CreateTransaction>((event, emit) async {
      print("start working create transaction income");
      try {
        Map<String, dynamic> response = await TransactionRepository()
            .createTransaction(
                event.statementType,
                event.walletId,
                event.imageUrl,
                event.stmTransaction,
                event.dateTimeTransaction,
                event.desctiption,
                event.transactionCategoryId);
        if (response['data'] == null) {
          print(
              "not created transacton income in transaction bloc : ${response['data']}");
        } else {
          print("create transacton income in transaction bloc success");
          emit(state.copyWith(
              id: response['data']['id'],
              stmTransaction: response['data']['stmTransaction'],
              statementType: event.statementType,
              description: response['data']['description'],
              walletId: response['data']['wid'],
              incomeStatus: TransactionStatus.loaded));
          print("after create income status is : ${state.incomeStatus}");
        }
      } catch (e) {
        emit(state.copyWith(incomeStatus: TransactionStatus.loading));
        print("Error creating transacton income in transaction bloc");
      }
    });

    on<CreateTransactionGoal>((event, emit) async {
      print("start working create transaction goal");
      try {
        Map<String, dynamic> response =
            await TransactionRepository().createTransactionGoal(
          event.walletId,
          event.imageUrl,
          event.stmTransaction,
          event.dateTimeTransaction,
          event.desctiption,
          event.goalIdGoal,
        );
        if (response['data'] == null) {
          print(
              "not created transacton goal in transaction bloc : ${response['data']}");
        } else {
          print("create transacton goal in transaction bloc success");
          emit(state.copyWith(
              id: response['data']['id'],

              stmTransaction: response['data']['stmTransaction'],
              description: response['data']['description'],
              walletId: response['data']['wid'],
              goalId: response['data']['goalId'],
              goalStatus: TransactionStatus.loaded));
          print("after create income status is : ${state.incomeStatus}");
        }
      } catch (e) {
        emit(state.copyWith(incomeStatus: TransactionStatus.loading));
        print("Error creating transacton income in transaction bloc");
      }
    });


    on<CreateTransactionDebt>((event, emit) async {
      print("start working create transaction goal");
      try {
        Map<String, dynamic> response =
            await TransactionRepository().createTransactionDebt(
          event.walletId,
          event.imageUrl,
          event.stmTransaction,
          event.dateTimeTransaction,
          event.desctiption,
          event.debtIdDebt,
        );
        if (response['data'] == null) {
          print(
              "not created transacton goal in transaction bloc : ${response['data']}");
        } else {
          print("create transacton debt in transaction bloc success");
          emit(state.copyWith(
              debtStatus: TransactionStatus.loaded));
        }
      } catch (e) {
         emit(state.copyWith(debtStatus: TransactionStatus.loading));
        print("Error creating transacton income in transaction bloc");
      }
    });

     on<DeleteTransaction>((event, emit) async {
      try {
        print("start step delete account bloc");
         await TransactionRepository().deleteTransaction(event.transactionId , event.walletId);
        final List<dynamic> newListTransaction = [...state.transactionList!];
        print("new list transaction : ${newListTransaction}");
        newListTransaction.removeWhere((element) => element['id'] == event.transactionId);
              print("after new list transaction : ${newListTransaction}");
        emit(state.copyWith(deleteTransactionStatus: TransactionStatus.loaded , transactionList: newListTransaction));
        print("check list : ${state.transactionList}");
       
      } catch (error) {
        print("error delete account bloc: $error");
        throw error;
      }
    });


     on<UpdateTransactionInEx>((event, emit) async {
      print("start working update transaction income");
      try {
        Map<String, dynamic> response = await TransactionRepository()
            .updateTransactionInEx(
                event.statementType,
                event.transactionCategoryId,
                event.walletId,
                event.stmTransaction,
                event.dateTimeTransaction,
                event.imageUrl ,
                event.description,
                event.transactionId);
        if (response['data'] == null) {
          print(
              "not update transacton income in transaction bloc : ${response['data']}");
        } else {
          print("update transacton income in transaction bloc success");
          emit(state.copyWith(
              updateTransactionInEx: TransactionStatus.loaded));
          print("after update income status is : ${state.incomeStatus}");
        }
      } catch (e) {
        emit(state.copyWith(updateTransactionInEx: TransactionStatus.loading));
        print("Error update transacton income in transaction bloc");
      }
    });


     on<UpdateTransactionGoal>((event, emit) async {
      print("start working update transaction income");
      try {
        Map<String, dynamic> response = await TransactionRepository()
            .updateTransactionGoal(
                event.goalId ,
                event.statementType,
                event.transactionCategoryId,
                event.walletId,
                event.stmTransaction,
                event.dateTimeTransaction,
                event.imageUrl ,
                event.description,
                event.transactionId);
        if (response['data'] == null) {
          print(
              "not update transacton goal in transaction bloc : ${response['data']}");
        } else {
          print("update transacton goal in transaction bloc success");
          emit(state.copyWith(
              updateTransactionGoal: TransactionStatus.loaded));
          print("after update goal status is : ${state.incomeStatus}");
        }
      } catch (e) {
        emit(state.copyWith(updateTransactionGoal: TransactionStatus.loading));
        print("Error update transacton goal in transaction bloc");
      }
    });

    on<UpdateTransactionDebt>((event, emit) async {
      print("start working update transaction income");
      try {
        Map<String, dynamic> response = await TransactionRepository()
            .updateTransactionDebt(
                event.debtId ,
                event.statementType,
                event.transactionCategoryId,
                event.walletId,
                event.stmTransaction,
                event.dateTimeTransaction,
                event.imageUrl ,
                event.description,
                event.transactionId);
        if (response['data'] == null) {
          print(
              "not update transacton debt in transaction bloc : ${response['data']}");
        } else {
          print("update transacton debt in transaction bloc success");
          emit(state.copyWith(
              updateTransactionDebt: TransactionStatus.loaded));
          print("after update debt status is : ${state.incomeStatus}");
        }
      } catch (e) {
        emit(state.copyWith(updateTransactionDebt: TransactionStatus.loading));
        print("Error update transacton debt in transaction bloc");
      }
    });
  }
}
