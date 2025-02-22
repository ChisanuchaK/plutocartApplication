import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:plutocart/src/blocs/transaction_bloc/bloc/transaction_bloc.dart';
import 'package:plutocart/src/blocs/wallet_bloc/bloc/wallet_bloc.dart';
import 'package:plutocart/src/interfaces/slide_pop_up/filter/filter_month.dart';
import 'package:plutocart/src/interfaces/slide_pop_up/slide_popup_dialog.dart';
import 'package:plutocart/src/popups/action_popup.dart';
import 'package:plutocart/src/popups/loading_page_popup.dart';

class FilterTransaction extends StatefulWidget {
  const FilterTransaction({Key? key}) : super(key: key);

  @override
  _FilterTransactionState createState() => _FilterTransactionState();
}

class _FilterTransactionState extends State<FilterTransaction> {
  TextEditingController yearController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  TextEditingController walletController = TextEditingController();
  int selectedMonthIndex = -1;
  int selectedWalletIndex = -1;

  void resetData() {
    yearController.clear();
    monthController.clear();
    walletController.clear();
    selectedMonthIndex = -1;
    selectedWalletIndex = -1;
  }

  FilterMonth filterMonth = FilterMonth();
  List<Map<String, dynamic>> listTypeMonth = [];

  @override
  Widget build(BuildContext context) {
    listTypeMonth = filterMonth.listTypeMonth;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
                          color: Color(0xFF15616D),
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      Text(
                        "Find your transaction",
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
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        icon: SizedBox(
                          child: ImageIcon(
                            AssetImage('assets/icon/cancel_icon.png'),
                          ),
                        ),
                        color: Color(0xFF15616D),
                        iconSize: 20,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Month",
                    style: TextStyle(
                      color: Color(0xFF15616D),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder(),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        monthController.clear();
                        selectedMonthIndex = -1;
                      });
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: Color(0XFF989898),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 20.0, // Spacing between columns
                mainAxisSpacing: 20.0, // Spacing between rows
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                children: List.generate(listTypeMonth.length, (index) {
                  return Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Color(0XFF15616D), // Border color
                          ),
                        ),
                        backgroundColor: selectedMonthIndex == index
                            ? Color(0XFF15616D)
                            : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedMonthIndex = index;
                        });
                        monthController.text =
                            "${listTypeMonth[index]['keyMonth']}";
                      },
                      child: Text('${listTypeMonth[index]['typeName']}',
                          style: TextStyle(
                            color: selectedMonthIndex == index
                                ? Colors.white
                                : Color(0XFF15616D),
                          )),
                    ),
                  );
                }),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Year",
                    style: TextStyle(
                      color: Color(0xFF15616D),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder(),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        yearController.clear();
                      });
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: Color(0XFF989898),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: () {
                  DateTime now = DateTime.now();
                  selectPeriod(context, now.year, yearController, 1900, 2200);
                },
                child: AbsorbPointer(
                  absorbing: true,
                  child: TextField(
                    readOnly: true,
                    controller: yearController,
                    style: TextStyle(
                      color: Color(0xFF15616D),
                    ),
                    decoration: InputDecoration(
                      // labelText: "Year",
                      labelStyle: TextStyle(color: Color(0xFF1A9CB0)),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF15616D)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 1, color: Color(0xFF15616D)),
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
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Wallet",
                    style: TextStyle(
                      color: Color(0xFF15616D),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                        CircleBorder(),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        walletController.clear();
                        selectedWalletIndex = -1;
                      });
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(
                        color: Color(0XFF989898),
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  )
                ],
              ),
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisSpacing: 20.0, // Spacing between columns
                mainAxisSpacing: 20.0, // Spacing between rows
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                children: List.generate(
                    context.read<WalletBloc>().state.wallets.length, (index) {
                  return BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      return Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Color(0XFF15616D), // Border color
                              ),
                            ),
                            backgroundColor: selectedWalletIndex == index
                                ? Color(0XFF15616D)
                                : Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              selectedWalletIndex = index;
                              walletController.text =
                                  "${state.wallets[index].walletId}";
                              print(
                                  "walletController : ${walletController.text}");
                            });
                          },
                          child: Text(
                            '${state.wallets[index].walletName}',
                            style: TextStyle(
                              color: selectedWalletIndex == index
                                  ? Colors.white
                                  : Color(0XFF15616D),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              SizedBox(
                height: 16,
              ),
              ActionPopup(
                isFullField: true,
                bottonFirstName: "Clear All",
                bottonSecondeName: "Apply",
                bottonFirstNameFunction: () {
                  setState(() {
                    resetData();
                  });
                  print("reset year : ${yearController.text}");
                  print("reset month : ${monthController.text}");
                  print("reset wallet : ${walletController.text}");
                },
                bottonSecondeNameFunction: () async {
                  int walletId = walletController.text == ""
                      ? 0
                      : int.parse(walletController.text);
                  int month = monthController.text == ""
                      ? 0
                      : int.parse(monthController.text);
                  int year = yearController.text == ""
                      ? 0
                      : int.parse(yearController.text);

                  context.read<TransactionBloc>().add(ResetTransactionList());

                  context
                      .read<TransactionBloc>()
                      .add(UpdateFilterStatus(walletId, month, year));

                  context
                      .read<TransactionBloc>()
                      .add(GetTransactionList(walletId, month, year));
                  showLoadingPagePopUp(context);
                  await Future.delayed(Duration(seconds: 1));
                  Navigator.popUntil(context, (route) => route.isFirst);
                  context.read<TransactionBloc>().stream.listen((event) {
                    if (event.getTransactionStatus ==
                        TransactionStatus.loaded) {
                      context
                          .read<TransactionBloc>()
                          .add(StatusLoadTransactionList());
                      //  Navigator.pop(context);
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  });
                },
              )
            ],
          ),
        ),
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
