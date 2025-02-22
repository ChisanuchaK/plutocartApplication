import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plutocart/src/blocs/debt_bloc/debt_bloc.dart';
import 'package:plutocart/src/blocs/goal_bloc/goal_bloc.dart';
import 'package:plutocart/src/blocs/graph_bloc/graph_bloc.dart';
import 'package:plutocart/src/blocs/transaction_bloc/bloc/transaction_bloc.dart';
import 'package:plutocart/src/blocs/wallet_bloc/bloc/wallet_bloc.dart';
import 'package:plutocart/src/repository/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<ResetLogin>((event, emit) {
      emit(LoginState()); // Reset the state to the initial state
    });

    // Guest
    on<LoginGuest>((event, emit) async {
      try {
        Map<String, dynamic> response = await LoginRepository().loginGuest();
        print("response loginGuest repository working ? : ${response['data']}");
        if (response['data']['imei'] == null) {
          print("imei not found in class login bloc function loginGuest");
          final newState = state.copyWith(signInGuestSuccess: false);
          emit(newState);
        } else {
          final newState = state.copyWith(
            imei: response['data']['imei'],
            accountRole: response['data']['accountRole'],
            accountId: response['data']['accountId'],
            signInGuestSuccess: true,
          );
          print(
              "imei found in class login bloc function loginGuest imei : ${response['data']['imei']}");
          print(
              "imei found in class login bloc function loginGuest accountRole : ${response['data']['accountRole']}");
          print(
              "imei found in class login bloc function loginGuest accountId : ${response['data']['accountId']}");
          print(
              "imei found in class login bloc function loginGuest signInGuestSuccess : ${newState.signInGuestSuccess}");
          emit(newState);
        }
      } catch (e) {
        print("not sign in guest account in login bloc class : $e");
        final newState = state.copyWith(signInGuestSuccess: false);
        print(
            "imei not found in class login bloc function loginGuest signInGuestSuccess : ${newState.signInGuestSuccess}");

        emit(newState);
        // อย่าลืมเรียกใช้ emit(newState); เพื่ออัพเดทสถานะใน BLoC
      }
    });

    on<CreateAccountGuest>((event, emit) async {
      print("start working create account guest");
      try {
        Map<String, dynamic> response =
            await LoginRepository().createAccountGuest();
        if (response['data'] == null) {
          print(
              "not created account guest in login bloc : ${response['data']}");
        } else {
          print("create account guest in login bloc success");
          emit(state.copyWith(
              accountId: response['data']['accountId'],
              imei: response['data']['imei'],
              hasAccountGuest: false,
              signUpGuestSuccess: true));
          print(
              "check state imei from create account guest Login bloc: ${state.imei}");
          print(
              "check state accountId from create account guest Login bloc: ${state.accountId}");
          print(
              "check state accountRole from create account guest Login bloc: ${state.accountRole}");
        }
      } catch (e) {
        emit(state.copyWith(hasAccountGuest: true, signUpGuestSuccess: false));
        print(
            "not call login repository createAccountGuesy() in class Login bloc");
      }
    });

    // Member

    on<CreateAccountMember>((event, emit) async {
      try {
        Map<String, dynamic> response =
            await LoginRepository().createAccountMember();
        if (response.isNotEmpty) {
          print("start create account customer in LoginBloc");
          emit(state.copyWith(
              accountId: response['data']['accountId'],
              email: response['data']['email'],
              accountRole: response['data']['accountRole'],
              hasAccountMember: false,
              signUpMemberSuccess: true,
              signInMemberSuccess: true));
          print(
              "check state imei from create account customer Login bloc: ${state.imei}");
          print(
              "check state accountId from create account customer Login bloc: ${state.accountId}");
          print(
              "check state accountRole from create account customer Login bloc: ${state.accountRole}");
          print(
              "check state email from create account customer Login bloc: ${state.email}");
        }
      } catch (e) {
        final storage = FlutterSecureStorage();
        String? email = await storage.read(key: "email");
        print("check state  from create account customer Login bloc error:");
        print(
            "check state  from create account customer Login bloc errors: ${email}");
        print(
            "check state  from create account customer Login bloc errorss: ${state.accountId}");
        if (email != null) {
          emit(state.copyWith(
              hasAccountMember: false,
              signUpMemberSuccess: true,
              signInMemberSuccess: true,
              email: email));
        } else {
          emit(state.copyWith(
            hasAccountMember: true,
            signUpMemberSuccess: false,
            signInMemberSuccess: false,
          ));
        }
      }
    });

    on<LoginMember>((event, emit) async {
      Map<String, dynamic> response = await LoginRepository().loginMember();
      print(
          "response loginCustomer after create repository working ? : ${response['data']}");
      if (response['data']['email'] == null) {
        print(
            "email not found in class login bloc function loginCustomer after create");
      } else {
        emit(state.copyWith(
            imei: response['data']['imei'],
            accountRole: response['data']['accountRole'],
            accountId: response['data']['accountId'],
            email: response['data']['email']));
      }
    });

    on<LogOutAccountMember>((event, emit) async {
      LoginRepository().LogOutEmailGoolge();
      emit(state.copyWith(email: ""));
    });

    on<loginEmailGoole>((event, emit) async {
      try {
        Map<String, dynamic> response =
            await LoginRepository().loginEmailGoogle();
        print("starto1 : ${response['data']['email']}");
        print("starto1 : ${response['data']['imei']}");
        if (response['data']['email'] == null) {
          print(
              "response loginCustomer after create repository loginEmailGoole working ? : ${response['data']}");
          emit(state.copyWith(signInGoogleStatus: false));
        } else {
          print(
              "signin customer after create repository loginEmailGoole working ? :");
          emit(state.copyWith(
              accountId: response['data']['accountId'],
              email: response['data']['email'],
              imei: response['data']['imei'],
              signInGoogleStatus: true));
        }
      } catch (error) {
        print('Error loginEmailGoole during account creation: $error');
        final newState = state.copyWith(signInGoogleStatus: false);
        emit(newState);
      }
    });

    // Delete account bloc

    on<DeleteAccount>((event, emit) async {
      final storage = FlutterSecureStorage();
      try {
        print("start step delete account bloc");
        await LoginRepository().deleteAccountById();
        ResetLogin();
        ResetWallet();
        ResetTransaction();
        ResetGoal();
        ResetDebt();
        ResetGraph();
        storage.deleteAll();
      } catch (error) {
        print("error delete account bloc: $error");
        throw error;
      }
    });

    // update account bloc
    on<UpdateAccountToMember>((event, emit) async {
      final storage = FlutterSecureStorage();
      String? email = await storage.read(key: "email");
      try {
        print("start update account in bloc");
        Map<String, dynamic> response =
            await LoginRepository().updateEmailToMember();
        print("after update in bloc: $response");
        if (response['data']['email'] == null ||
            (email == " " || email!.isEmpty)) {
          print(
              "response loginCustomer after update account guest to member repository loginEmailGoole working ? : ${response['data']}");
          emit(state.copyWith(
              signInGoogleStatus: false,
              accountRole: "Guest",
              email: null,
              isUpdateAccount: false));
        } else {
          print(
              "signin customer after update account guest to member repository loginEmailGoole working ? :");
          emit(state.copyWith(
            email: response['data']['email'],
            signInGoogleStatus: true,
            isUpdateAccount: true,
            isUpdateFail: false,
            accountRole: "Member",
          ));
        }
      } catch (error) {
        // print(
        //     'Error loginEmailGoole during account guest to member creation: $error');
        final newState = state.copyWith(
          signInGoogleStatus: false,
          isUpdateAccount: false,
          isUpdateFail: true,
          accountRole: "Guest",
        );
        emit(newState);
        print(
            'Error loginEmailGoole during account guest to member creation: $state');
      }
    });
  }
}
