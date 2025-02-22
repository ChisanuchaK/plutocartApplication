import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:plutocart/src/blocs/debt_bloc/debt_bloc.dart';
import 'package:plutocart/src/interfaces/slide_pop_up/slide_popup_dialog.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/DatePickerFieldOnlyDay.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/amount_text_field.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/change_formatter.dart';
import 'package:plutocart/src/popups/action_popup.dart';
import 'package:plutocart/src/popups/custom_alert_popup.dart';
import 'package:plutocart/src/popups/loading_page_popup.dart';

class AddDebtPopup extends StatefulWidget {
  const AddDebtPopup({Key? key}) : super(key: key);

  @override
  _AddDebtPopupState createState() => _AddDebtPopupState();
}

class _AddDebtPopupState extends State<AddDebtPopup> {
  TextEditingController nameDebtController = new TextEditingController();
  TextEditingController totalDebtController = new TextEditingController();
  TextEditingController totalPeriodController = new TextEditingController();
  TextEditingController paidPeriodController = new TextEditingController();
  TextEditingController monthlyPaymentController = new TextEditingController();
  TextEditingController debtPaidController = new TextEditingController();
  TextEditingController moneyLeanderController = new TextEditingController();
  TextEditingController latestDatePayController = new TextEditingController();
  bool? fullField;
  int? integerValuePayPeriod;
  int? integerValueHowMYPay;
  double? calMonthlyPayment;
  double? calDetPaid;
  bool? toggleLatestPaid;

  void checkFullFiedl() {
    fullField = (nameDebtController.text.length <= 0 ||
            totalDebtController.text.length <= 0 ||
            totalPeriodController.text.length <= 0 ||
            paidPeriodController.text.length <= 0 ||
            monthlyPaymentController.text.length <= 0 ||
            debtPaidController.text.length <= 0 ||
            moneyLeanderController.text.length <= 0 ||
            latestDatePayController.text.length <= 0)
        ? false
        : true;
  }

  @override
  void initState() {
    integerValuePayPeriod = 1;
    integerValueHowMYPay = 0;
    checkFullFiedl();
    nameDebtController.addListener(() {
      setState(() {
        checkFullFiedl();
      });
    });

    totalDebtController.addListener(() {
      setState(() {
        checkFullFiedl();
        if (totalPeriodController.text.length != 0 &&
            totalPeriodController.text.length != 0 &&
            paidPeriodController.text.length != 0) {
          calMonthlyPayment = double.parse(totalDebtController.text) /
              double.parse(totalPeriodController.text);
          monthlyPaymentController.text = calMonthlyPayment!.toStringAsFixed(2);
          calDetPaid = double.parse(paidPeriodController.text) *
              double.parse(monthlyPaymentController.text);
          debtPaidController.text = calDetPaid!.toStringAsFixed(2);
        } else if (totalPeriodController.text.length != 0 &&
            totalPeriodController.text.length != 0) {
          calMonthlyPayment = double.parse(totalDebtController.text) /
              double.parse(totalPeriodController.text);
          monthlyPaymentController.text = calMonthlyPayment!.toStringAsFixed(2);
        }
      });
    });
    totalPeriodController.addListener(() {
      setState(() {
        checkFullFiedl();
        if (totalDebtController.text.length != 0 &&
            totalPeriodController.text.length != 0) {
          calMonthlyPayment = double.parse(totalDebtController.text) /
              double.parse(totalPeriodController.text);
          monthlyPaymentController.text = calMonthlyPayment!.toStringAsFixed(2);
        }
      });
    });

    paidPeriodController.addListener(() {
      setState(() {
        checkFullFiedl();
        if (paidPeriodController.text.length != 0 &&
            monthlyPaymentController.text.length != 0 &&
            totalDebtController.text.length != 0) {
          calDetPaid = double.parse(paidPeriodController.text) *
              double.parse(monthlyPaymentController.text);
          debtPaidController.text = calDetPaid!.toStringAsFixed(2);
        }

        if (int.parse(paidPeriodController.text) == 0) {
          toggleLatestPaid = false;
        } else {
          toggleLatestPaid = true;
        }
      });
    });
    monthlyPaymentController.addListener(() {
      setState(() {
        checkFullFiedl();
      });
    });
    paidPeriodController.addListener(() {
      setState(() {
        checkFullFiedl();
      });
    });
    debtPaidController.addListener(() {
      setState(() {
        checkFullFiedl();
      });
    });
    moneyLeanderController.addListener(() {
      setState(() {
        checkFullFiedl();
      });
    });

    DateTime now = DateTime.now();
    String formattedDateTime =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    latestDatePayController.text = formattedDateTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Debt",
                    style: TextStyle(
                      color: Color(0xFF15616D),
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Text(
                    "Record various debts and manage them!",
                    style: TextStyle(
                      color: Color(0xFF898989),
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            maxLength: 15,
            controller: nameDebtController,
            decoration: InputDecoration(
              labelText: "Name of Your Debt",
              labelStyle: TextStyle(
                color: nameDebtController.text.length != 0
                    ? Color(0xFF1A9CB0)
                    : Color(0XFFDD0000),
              ),
              counterStyle: TextStyle(color: Color(0xFF15616D)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: nameDebtController.text.length != 0
                      ? Color(0xFF15616D)
                      : Color(0XFFDD0000),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: nameDebtController.text.length != 0
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
              if (value.contains(' ') && nameDebtController.text.length == 1) {
                nameDebtController.text = value.replaceAll(' ', '');
              }
              setState(() {});
            },
          ),
          SizedBox(
            height: 15,
          ),
          AmountTextField(
              amountMoneyController: totalDebtController,
              nameField: "Total debt"),
          SizedBox(height: 15),
          Opacity(
            opacity: totalDebtController.text.length == 0 ? 0.3 : 1,
            child: GestureDetector(
              onTap: () {
                if (totalDebtController.text.length != 0) {
                  int numberOfPaidPeriod = paidPeriodController.text.length > 0
                      ? int.parse(paidPeriodController.text)
                      : 0;
                  print(
                      "numberOfPaidPeriod: + numberOfPaidPeriod : ${numberOfPaidPeriod}");
                  selectPeriod(context, integerValuePayPeriod!,
                      totalPeriodController, 1, 360);
                }
              },
              child: AbsorbPointer(
                absorbing: true,
                child: TextField(
                  readOnly: true,
                  controller: totalPeriodController,
                  style: TextStyle(
                    color: Color(0xFF15616D),
                  ),
                  decoration: InputDecoration(
                    labelText: "Total period",
                    labelStyle: TextStyle(
                        color: totalPeriodController.text.length != 0
                            ? Color(0xFF1A9CB0)
                            : Color(0XFFDD0000)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: totalPeriodController.text.length != 0
                              ? Color(0xFF15616D)
                              : Color(0XFFDD0000)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: totalPeriodController.text.length != 0
                              ? Color(0xFF15616D)
                              : Color(0XFFDD0000)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/icon/topup_icon.png'),
                        color: Color(0xFF15616D),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Opacity(
            opacity: totalPeriodController.text.length == 0 ? 0.3 : 1,
            child: AmountTextField(
                readOnly: totalPeriodController.text.length == 0 ? true : false,
                helperText: "This field auto-generated, editable if needed.",
                amountMoneyController: monthlyPaymentController,
                nameField: "Monthly payment"),
          ),
          SizedBox(
            height: 15,
          ),
          Opacity(
            opacity: totalPeriodController.text.length == 0 ? 0.3 : 1,
            child: GestureDetector(
              onTap: () {
                int parsePayPeriodToInt = int.parse(totalPeriodController.text);

                selectPeriod(
                    context, 0, paidPeriodController, 0, parsePayPeriodToInt);
              },
              child: AbsorbPointer(
                absorbing: true,
                child: TextField(
                  readOnly: true,
                  controller: paidPeriodController,
                  style: TextStyle(
                    color: Color(0xFF15616D),
                  ),
                  decoration: InputDecoration(
                    helperText:
                        "This field auto-generated, editable if needed.",
                    labelText: "Paid period(s)",
                    helperStyle: TextStyle(color: Color(0xFF1A9CB0)),
                    labelStyle: TextStyle(
                        color: paidPeriodController.text.length != 0
                            ? Color(0xFF1A9CB0)
                            : Color(0XFFDD0000)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: paidPeriodController.text.length != 0
                              ? Color(0xFF15616D)
                              : Color(0XFFDD0000)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: paidPeriodController.text.length != 0
                              ? Color(0xFF15616D)
                              : Color(0XFFDD0000)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    suffixIcon: IconButton(
                      icon: ImageIcon(
                        AssetImage('assets/icon/topup_icon.png'),
                        color: Color(0xFF15616D),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Opacity(
            opacity: paidPeriodController.text.length == 0 ? 0.3 : 1,
            child: AmountTextField(
                readOnly: paidPeriodController.text.length == 0 ? true : false,
                helperText: "This field auto-generated, editable if needed.",
                amountMoneyController: debtPaidController,
                nameField: "Debt paid"),
          ),
          SizedBox(
            height: 15,
          ),
          TextField(
            maxLength: 15,
            controller: moneyLeanderController,
            decoration: InputDecoration(
              labelText: "Money lender",
              labelStyle: TextStyle(
                color: moneyLeanderController.text.length != 0
                    ? Color(0xFF1A9CB0)
                    : Color(0XFFDD0000),
              ),
              counterStyle: TextStyle(color: Color(0xFF15616D)),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: moneyLeanderController.text.length != 0
                      ? Color(0xFF15616D)
                      : Color(0XFFDD0000),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: moneyLeanderController.text.length != 0
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
              setState(() {});
            },
          ),
          toggleLatestPaid == true
              ? DatePickerFieldOnlyDay(
                  tranDateController: latestDatePayController,
                  nameField: "Latest paid",
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ActionPopup(
              bottonFirstName: "Cancel",
              bottonSecondeName: "Add",
              isFullField: fullField,
              bottonFirstNameFunction: () {
                Navigator.pop(context);
              },
              bottonSecondeNameFunction: () {
                if (nameDebtController.text.length <= 0 ||
                    totalDebtController.text.length <= 0 ||
                    totalPeriodController.text.length <= 0 ||
                    paidPeriodController.text.length <= 0 ||
                    monthlyPaymentController.text.length <= 0 ||
                    debtPaidController.text.length <= 0 ||
                    moneyLeanderController.text.length <= 0 ||
                    latestDatePayController.text.length <= 0) {
                  // customAlertPopup(context, "Information missing",
                  //     Icons.error_outline_rounded, Colors.red.shade200);
                  null;
                } else {
                  String nameOfYourDebt = nameDebtController.text;
                  double totalDebt = double.parse(totalDebtController.text);
                  int totalPeriod = int.parse(totalPeriodController.text);
                  int paidPeriod = int.parse(paidPeriodController.text);
                  double monthlyPayment =
                      double.parse(monthlyPaymentController.text);
                  double debtPaid = double.parse(debtPaidController.text);
                  String moneyLender = moneyLeanderController.text;
                  String debtDate =
                      changeFormatter(latestDatePayController.text);
                  showLoadingPagePopUp(context);
                  context.read<DebtBloc>().add(CreateDebt(
                      nameOfYourDebt,
                      totalDebt,
                      totalPeriod,
                      paidPeriod,
                      monthlyPayment,
                      debtPaid,
                      moneyLender,
                      toggleLatestPaid == true ? debtDate : ""));
                  context.read<DebtBloc>().stream.listen((state) {
                    if (state.createDebtStatus == DebtStatus.loaded) {
                      context.read<DebtBloc>().add(ResetDebtStatus());
                      context.read<DebtBloc>().add(
                          UpdateStatusNumberDebt(state.statusFilterDebtNumber));
                      context.read<DebtBloc>().add(
                          GetDebtByAccountId(state.statusFilterDebtNumber));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  selectPeriod(
      BuildContext context,
      int currentValue,
      TextEditingController textEditingController,
      int minValue,
      int maxValue) async {
    showSlideDialog(
        context: context,
        child: AlertDialog(
          elevation: 0,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  NumberPicker(
                    value: currentValue,
                    minValue: minValue,
                    maxValue: maxValue,
                    onChanged: (value) {
                      setState(() {
                        currentValue = value;
                      });
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 1,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF15616D),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),
                        onPressed: () {
                          textEditingController.text = currentValue.toString();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Confirm value: $currentValue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  )
                ],
              );
            },
          ),
        ),
        barrierColor: Colors.white.withOpacity(0.7),
        backgroundColor: Colors.white,
        hightCard: 1.66);
  }
}
