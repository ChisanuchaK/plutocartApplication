import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plutocart/src/blocs/goal_bloc/goal_bloc.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/DatePickerFieldOnlyDay.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/amount_text_field.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/change_formatter.dart';
import 'package:plutocart/src/popups/action_popup.dart';
import 'package:plutocart/src/popups/loading_page_popup.dart';

class AddGoalPopup extends StatefulWidget {
  const AddGoalPopup({Key? key}) : super(key: key);

  @override
  _AddGoalPopupState createState() => _AddGoalPopupState();
}

class _AddGoalPopupState extends State<AddGoalPopup> {
  TextEditingController budgetGoalController = TextEditingController();
  TextEditingController yourSaveMoneyController = TextEditingController();
  TextEditingController tranDateController = TextEditingController();
  TextEditingController nameGoalController = TextEditingController();
  bool? fullField;

  void checkFullField() {
    fullField = (budgetGoalController.text.length <= 0 ||
            yourSaveMoneyController.text.length <= 0 ||
            nameGoalController.text.length <= 0)
        ? false
        : true;
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    nameGoalController.addListener(() {
      setState(() {
        checkFullField();
      });
    });
    budgetGoalController.addListener(() {
      setState(() {
        checkFullField();
      });
    });
    yourSaveMoneyController.addListener(() {
      setState(() {
        checkFullField();
      });
    });
    String formattedDateTime =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    tranDateController.text = formattedDateTime;
    context.read<GoalBloc>().add(GetGoalByAccountId(
        context.read<GoalBloc>().state.statusFilterGoalNumber));
    super.initState();
  }

  void dispose() {
    budgetGoalController.dispose();
    yourSaveMoneyController.dispose();
    tranDateController.dispose();
    nameGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Goals",
              style: TextStyle(
                color: Color(0xFF15616D),
                fontSize: 24,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            Text(
              "You can set 'Goals' of your life!",
              style: TextStyle(
                color: Color(0xFF898989),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
            TextField(
              maxLength: 15,
              controller: nameGoalController,
              decoration: InputDecoration(
                labelText: "Name of Your Goal",
                labelStyle: TextStyle(
                  color: nameGoalController.text.length != 0
                      ? Color(0xFF1A9CB0)
                      : Color(0XFFDD0000),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: nameGoalController.text.length != 0
                        ? Color(0xFF15616D)
                        : Color(0XFFDD0000),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: nameGoalController.text.length != 0
                        ? Color(0xFF15616D)
                        : Color(0XFFDD0000),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              keyboardType: TextInputType.text,
              style: TextStyle(
                color: Color(0xFF15616D),
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
              onChanged: (value) {
                if (value.contains(' ') &&
                    nameGoalController.text.length == 1) {
                  nameGoalController.text = value.replaceAll(' ', '');
                }
                setState(() {});
              },
            ),
            AmountTextField(
              amountMoneyController: budgetGoalController,
              nameField: "Total goal",
            ),
            AmountTextField(
              amountMoneyController: yourSaveMoneyController,
              nameField: "Collected money",
            ),
            DatePickerFieldOnlyDay(
              tranDateController: tranDateController,
              nameField: "Selected Date",
            ),
            ActionPopup(
              isFullField: fullField,
              bottonFirstName: "Cancel",
              bottonSecondeName: "Add",
              bottonFirstNameFunction: () {
                Navigator.pop(context);
              },
              bottonSecondeNameFunction: () {
                if (nameGoalController.text.length <= 0 ||
                    budgetGoalController.text.length <= 0 ||
                    yourSaveMoneyController.text.length <= 0 ||
                    tranDateController.text.length <= 0) {
                  // customAlertPopup(context, "Information missing",
                  //     Icons.error_outline_rounded, Colors.red.shade200);
                  null;
                } else {
                  double amountGoal = double.parse(budgetGoalController.text);
                  double dificitGoal =
                      double.parse(yourSaveMoneyController.text);
                  String tranDateFormat =
                      changeFormatter(tranDateController.text);
                  showLoadingPagePopUp(context);
                  context.read<GoalBloc>().add(CreateGoal(
                      nameGoalController.text,
                      amountGoal,
                      dificitGoal,
                      tranDateFormat));
                  context.read<GoalBloc>().stream.listen((state) {
                    if (state.createGoalStatus == GoalStatus.loaded) {
                      print(
                          "status goal number : ${state.statusFilterGoalNumber}");
                      context.read<GoalBloc>().add(ResetGoalStatus());
                      context.read<GoalBloc>().add(
                          UpdateStatusNumberGoal(state.statusFilterGoalNumber));
                      context.read<GoalBloc>().add(
                          GetGoalByAccountId(state.statusFilterGoalNumber));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
