import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plutocart/src/repository/goal_repository.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc() : super(GoalState()) {
    on<ResetGoalStatus>((event, emit) async {
      emit(state.copyWith(
          createGoalStatus: GoalStatus.loading,
          amountGoal: 0.0,
          deficit: 0.0,
          nameGoal: ""));
    });

    on<ResetGoalStatusDelete>((event, emit) async {
      emit(state.copyWith(deleteGoalStatus: GoalStatus.loading));
    });
    on<ResetGoalCompleteStatus>((event, emit) async {
      emit(state.copyWith(goalComplete: false));
    });

    on<ResetGoal>((event, emit) async {
      emit(GoalState());
    });

    on<ResetUpdateGoalStatus>((event, emit) async {
      emit(state.copyWith(updateGoalStatus: GoalStatus.loading));
    });

    on<StatusCardGoal>(
      (event, emit) {
        emit(state.copyWith(statusCardGoal: event.statusCardGoal));
      },
    );

    on<CreateGoal>((event, emit) async {
      print("start working create transaction income");
      try {
        Map<String, dynamic> response =
            await GoalRepository().createGoalByAccountId(
          event.nameGoal,
          event.amountGoal,
          event.dificit,
          event.endDateGoalAdd!,
        );

        print("respone add goal : ${response['data']}");
        if (response['data'] == null) {
          print("not created goal in goal bloc : ${response['data']}");
        } else {
          DateTime dateTime = DateTime.parse(response['data']['endDateGoal']);
          print("create goal in goal bloc success");
          emit(state.copyWith(
              nameGoal: response['data']['nameGoal'],
              amountGoal: response['data']['totalGoal'],
              deficit: response['data']['collectedMoney'],
              endDateGoal: dateTime,
              createGoalStatus: GoalStatus.loaded));
          print("after create goal status is : ${state.createGoalStatus}");
          print("print state datetime : ${state.endDateGoal}");
        }
      } catch (e) {
        emit(state.copyWith(createGoalStatus: GoalStatus.loading));
        print("Error creating goal  in bloc bloc : ${e}");
      }
    });

    on<GetGoalByAccountId>(
      (event, emit) async {
        print("Start get goal in goal bloc");
        try {
          List<dynamic> response =
              await GoalRepository().getGoalByAccountId(event.status);

          if (response.isNotEmpty) {
            print("response is:  ${response}");
            emit(state.copyWith(
                goalList: response, getGoalStatus: GoalStatus.loaded));
          } else {
            emit(state.copyWith(getGoalStatus: GoalStatus.loaded));
          }
        } catch (e) {
          print("Error: $e");
        }
      },
    );

    on<CheckGoalComplete>(
      (event, emit) async {
        print("Start check goal in goal bloc");
        try {
          List<dynamic> response =
              await GoalRepository().getGoalByAccountId(null);
          int indexGoal =
              response.indexWhere((element) => element['id'] == event.goalId);
          print("show respinse goal : ${response[indexGoal]}");
          print("element  ${event.goalId}");
          print("defecit : ${response[indexGoal]['collectedMoney']}");
          print("amount : ${response[indexGoal]['totalGoal']}");
          print(
              "response[0]['deficit'] >= response[0]['amountGoal'] : ${response[indexGoal]['collectedMoney'] >= response[indexGoal]['totalGoal']}");
          if (response[indexGoal]['collectedMoney'] >=
              response[indexGoal]['totalGoal']) {
            print("response goal complete true");
            emit(state.copyWith(goalComplete: true));

            print("check state = : ${state.goalComplete}");
          } else {
            print("response goal complete false");
            emit(state.copyWith(goalComplete: false));
          }
        } catch (e) {
          print("Error: $e");
        }
      },
    );

    on<DeleteGoalByGoalId>((event, emit) async {
      try {
        print("start step delete account bloc");
        await GoalRepository().deleteGoal(event.goalId);
        final List<dynamic> newListGoal = [...state.goalList!];
        print("new list goal : ${newListGoal}");
        newListGoal.removeWhere((element) => element['id'] == event.goalId);
        print("after new list goal : ${newListGoal}");
        emit(state.copyWith(
            deleteGoalStatus: GoalStatus.loaded, goalList: newListGoal));
        print("check list : ${state.goalList}");
      } catch (error) {
        print("error delete account bloc: $error");
        throw error;
      }
    });

    on<UpdateGoalbyGoalId>((event, emit) async {
      try {
        print("start update account in bloc");
        Map<String, dynamic> response = await GoalRepository().updateGoal(
          event.goalId,
          event.nameGoal,
          event.amountGoal,
          event.deficit,
          event.endDateString,
        );
        print("after update in bloc: $response");

        if (response['data'] == null) {
          print("Error updating goal: ${response['error']}");
        } else {
          print("Update successful. Response data: ${response['data']}");

          if (response['data'] is Map<String, dynamic>) {
            emit(state.copyWith(
              updateGoalStatus: GoalStatus.loaded,
              nameGoal: response['data']['nameGoal'],
              amountGoal: response['data']['totalGoal'],
              deficit: response['data']['collectedMoney'],
              endDateGoalString: response['data']['endDateGoal'],
            ));
          } else {
            print("Invalid response data structure.");
          }
        }
      } catch (error) {
        print('Error updating goal: $error');
      }
    });

    on<UpdateStatusNumberGoal>(((event, emit) {
      emit(state.copyWith(goalList: [], statusFilterGoalNumber: event.status));
    }));
    on<CompleteGoal>((event, emit) async {
      try {
        print("start complete goal in bloc");
        Map<String, dynamic> response =
            await GoalRepository().completeGoal(event.goalId);
        print("after complete goal  in bloc: $response");

        if (response['data'] == null) {
          print("Error updating goal: ${response['error']}");
        } else {
          print("Update successful. Response data: ${response['data']}");

          if (response['data'] is Map<String, dynamic>) {
            emit(state.copyWith(
              updateGoalStatus: GoalStatus.loaded,
            ));
          } else {
            print("Invalid response data structure.");
          }
        }
      } catch (error) {
        print('Error updating goal: $error');
      }
    });
  }
}
