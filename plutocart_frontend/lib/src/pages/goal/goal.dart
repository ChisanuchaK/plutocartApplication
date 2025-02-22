import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plutocart/src/blocs/debt_bloc/debt_bloc.dart';
import 'package:plutocart/src/blocs/goal_bloc/goal_bloc.dart';
import 'package:plutocart/src/blocs/graph_bloc/graph_bloc.dart';
import 'package:plutocart/src/blocs/login_bloc/login_bloc.dart';
import 'package:plutocart/src/interfaces/slide_pop_up/slide_popup_dialog.dart';
import 'package:plutocart/src/pages/goal/companent_goal/filter_goal.dart';
import 'package:plutocart/src/popups/action_complete_popup.dart';
import 'package:plutocart/src/popups/goal_popup/add_goal_popup.dart';
import 'package:plutocart/src/popups/goal_popup/more_vert_goal.dart';
import 'package:plutocart/src/popups/setting_popup.dart';
import 'package:plutocart/src/popups/wallet_popup/create_wallet_popup.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({Key? key}) : super(key: key);

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  List<bool> statusCard = [];

  @override
  void initState() {
    context.read<DebtBloc>().add(UpdateStatusNumberDebt(0));
    context.read<DebtBloc>().add(GetDebtByAccountId(0));
    context.read<GraphBloc>().add(GetGraph(1));
    context.read<GraphBloc>().add(UpdateTypeGraph(1));
    context.read<GraphBloc>().add(UpdateGraphList());
    BlocProvider.of<GoalBloc>(context).state.goalList!.forEach((_) {
      statusCard.add(false);
    });
    context.read<GoalBloc>().stream.listen((event) {
      BlocProvider.of<GoalBloc>(context).state.goalList!.forEach((_) {
        statusCard.add(false);
      });
    });

    super.initState();
    print("check number : ${context.read<GoalBloc>().state.goalList!.length}");
    print("check numbera : ${statusCard.length}");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        return Skeletonizer(
          enabled: state.getGoalStatus == GoalStatus.loading,
          effect: ShimmerEffect(duration: Duration(seconds: 1)),
          child: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Goals",
                        style: TextStyle(
                          color: Color(0xFF15616D),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Image.asset(
                          "assets/icon/icon_launch.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return Row(
                        children: [
                          IconButton(
                              alignment: Alignment.centerRight,
                              splashRadius: 5,
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<CircleBorder>(
                                  CircleBorder(),
                                ),
                              ),
                              onPressed: () async {
                                await createGoal();
                                setState(() {
                                  context
                                      .read<GoalBloc>()
                                      .stream
                                      .listen((event) {
                                    statusCard = []; // Clear the list
                                    context.read<GoalBloc>().add(
                                        GetGoalByAccountId(
                                            event.statusFilterGoalNumber));
                                    BlocProvider.of<GoalBloc>(context)
                                        .state
                                        .goalList!
                                        .forEach((_) {
                                      statusCard.add(
                                          false); // Populate the list again if needed
                                    });
                                  });
                                });
                              },
                              icon: Image.asset(
                                'assets/icon/plus_icon.png',
                                width: 20,
                              )),
                          IconButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(),
                              ),
                            ),
                            splashRadius: 5,
                            onPressed: () {
                              SettingPopUp(
                                  state.accountRole, state.email, context);
                            },
                            icon: Icon(Icons.settings),
                            color: Color(0xFF15616D),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
              backgroundColor: Colors.white10,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  FilterGoal(),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        BlocBuilder<GoalBloc, GoalState>(
                          builder: (context, state) {
                            return Center(
                              child: state.goalList!.length == 0
                                  ? Container(
                                      constraints: BoxConstraints(
                                          minHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image(
                                            image: AssetImage(
                                                'assets/icon/icon_launch.png'),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.3,
                                          ),
                                          Text("No record",
                                              style: TextStyle(
                                                  color: Color(0xFF15616D),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto")),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: List.generate(
                                          state.goalList!.length, (index) {
                                        final Map<String, dynamic> goal =
                                            state.goalList![index];
                                        final DateTime inputDate =
                                            DateTime.parse(goal['endDateGoal']);
                                        final String formattedDate =
                                            DateFormat('dd MMM yyyy')
                                                .format(inputDate);
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                            height: statusCard[index] == true
                                                ? goal['statusGoal'] != 1
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.29
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.35
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.22,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                width: 1,
                                                color: Color(0XFF15616D),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  spreadRadius: 0,
                                                  blurRadius: 2,
                                                  offset: Offset(2, 2),
                                                ),
                                              ],
                                              color: Colors
                                                  .white, // Background color
                                            ),
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  foregroundColor:
                                                      Color(0XFF1A9CB0)),
                                              onPressed: () {
                                                statusCard[index] =
                                                    !statusCard[index];
                                                setState(() {});
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Row(
                                                          children: [
                                                            Image.network(
                                                              'https://res.cloudinary.com/dtczkwnwt/image/upload/v1706441684/category_images/Goals_76349a46-07b8-4024-97f5-9eb118aa533d.png',
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.1,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: Text(
                                                                  "${goal['nameGoal']}",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF15616D),
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Roboto")),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.08,
                                                        child: IconButton(
                                                          icon: Icon(
                                                            Icons
                                                                .more_vert_outlined,
                                                            color: Color(
                                                                0XFF898989), // Set the color here
                                                          ),
                                                          onPressed: () async {
                                                            more_vert(
                                                                goal['id'],
                                                                goal);
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 10),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.05,
                                                          decoration:
                                                              ShapeDecoration(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              side: BorderSide(
                                                                  width: 1,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                left: 0,
                                                                top: 0,
                                                                child:
                                                                    Container(
                                                                  width: goal['collectedMoney'] / goal['totalGoal'] >=
                                                                          1
                                                                      ? MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.8
                                                                      : goal['collectedMoney'] / goal['totalGoal'] <
                                                                              0.1
                                                                          ? MediaQuery.of(context).size.width *
                                                                              0.1
                                                                          : goal['collectedMoney'] / goal['totalGoal'] == 0.8
                                                                              ? MediaQuery.of(context).size.width * 0.733
                                                                              : goal['collectedMoney'] / goal['totalGoal'] > 0.8
                                                                                  ? MediaQuery.of(context).size.width * 0.777
                                                                                  : MediaQuery.of(context).size.width * goal['collectedMoney'] / goal['totalGoal'],
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.05,
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Color(
                                                                        0XFF1A9CB0),
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      side: BorderSide(
                                                                          width:
                                                                              1,
                                                                          color:
                                                                              Color(0XFF1A9CB0)),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                bottom: 8),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "${((goal['collectedMoney'] / goal['totalGoal']) * 100).abs().toStringAsFixed(0)}%",
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0XFF898989),
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Roboto",
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              2),
                                                                  child: Text(
                                                                      "${NumberFormat("#,##0.00").format(goal['collectedMoney'])}฿",
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF15616D),
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto")),
                                                                ),
                                                                Text("/",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF15616D),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontFamily:
                                                                            "Roboto")),
                                                                Text(
                                                                    "${NumberFormat("#,##0.00").format(goal['totalGoal'])}฿",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF15616D),
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontFamily:
                                                                            "Roboto")),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    "${formattedDate}",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0XFF898989),
                                                                        fontSize:
                                                                            12,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        fontFamily:
                                                                            "Roboto")),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      statusCard[index] == true
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                          "Collected money",
                                                                          style: TextStyle(
                                                                              color: Color(0xFF15616D),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Roboto")),
                                                                      Text(
                                                                          "${NumberFormat("#,##0.00").format(goal['collectedMoney'])} ฿",
                                                                          style: TextStyle(
                                                                              color: Color(0xFF2DC653),
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "Roboto")),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            15),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      decoration:
                                                                          ShapeDecoration(
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          side:
                                                                              BorderSide(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.zero, // หรือกำหนดรูปแบบได้ตามที่ต้องการ
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                          "Remainder",
                                                                          style: TextStyle(
                                                                              color: Color(0xFF15616D),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Roboto")),
                                                                      Text(
                                                                        "${NumberFormat("#,##0.00").format((goal['totalGoal'] - goal['collectedMoney']).abs())} ฿",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0XFF1A9CB0),
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              "Roboto",
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : SizedBox.shrink(),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  statusCard[index] == true
                                                      ? goal['statusGoal'] != 1
                                                          ? SizedBox.shrink()
                                                          : Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.8,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.055,
                                                              child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Color(0XFF15616D),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                      )),
                                                                  onPressed: () async {
                                                                    completeGoalAction(
                                                                        goal);
                                                                    context
                                                                        .read<
                                                                            GoalBloc>()
                                                                        .stream
                                                                        .listen(
                                                                            (event) {
                                                                      if (event
                                                                              .updateGoalStatus ==
                                                                          GoalStatus
                                                                              .loaded) {
                                                                        print(
                                                                            "aakim test update complete goal");
                                                                        context
                                                                            .read<GoalBloc>()
                                                                            .add(GetGoalByAccountId(event.statusFilterGoalNumber));
                                                                        context
                                                                            .read<GoalBloc>()
                                                                            .add(UpdateStatusNumberGoal(event.statusFilterGoalNumber));
                                                                        context
                                                                            .read<GoalBloc>()
                                                                            .add(ResetUpdateGoalStatus());
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Text("Complete")),
                                                            )
                                                      : SizedBox.shrink()
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  more_vert(int goalId, Map<String, dynamic> goal) {
    showSlideDialog(
        context: context,
        child: MoreVertGoal(goal: goal, goalId: goalId),
        barrierColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.white,
        hightCard: 1.3);
  }

  createGoal() async {
    showSlideDialog(
        context: context,
        child: AddGoalPopup(),
        barrierColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.white,
        hightCard: 2.5);
  }

  completeGoalAction(Map<String, dynamic> goal) async {
    showSlideDialog(
        context: context,
        child: ActionCompletePopup(
            keyname: "${goal['nameGoal']}",
            value: "${goal['totalGoal']}฿",
            nameAction: "Congratulations you Goal",
            imageIcon: Image.asset(
              'assets/icon/Congratulation_icon.png',
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            buttonFuction2: () =>
                context.read<GoalBloc>().add(CompleteGoal(goal['id']))),
        barrierColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.white,
        hightCard: 1.6);
  }

  createWallet() async {
    showSlideDialog(
        context: context,
        child: CreateWalletPopup(),
        barrierColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.white,
        hightCard: 1.75);
  }
}
