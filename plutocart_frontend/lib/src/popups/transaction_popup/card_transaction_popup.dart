import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plutocart/src/blocs/transaction_bloc/bloc/transaction_bloc.dart';
import 'package:plutocart/src/blocs/transaction_category_bloc/bloc/transaction_category_bloc.dart';
import 'package:plutocart/src/blocs/wallet_bloc/bloc/wallet_bloc.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/amount_text_field.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/change_formatter.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/date_picker_field.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/description_text_field.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/image_selection_screen.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/transaction_category_dropdown.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/transaction_type_dropdown.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/type_transaction_router.dart';
import 'package:plutocart/src/pages/transaction/component_transaction/wallet_dropdown.dart';
import 'package:plutocart/src/popups/action_popup.dart';

class CardTransactionPopup extends StatefulWidget {
  const CardTransactionPopup({Key? key}) : super(key: key);

  @override
  _CardTransactionPopupState createState() => _CardTransactionPopupState();
}

class _CardTransactionPopupState extends State<CardTransactionPopup> {
  @override
  void initState() {
    DateTime now = DateTime.now();
    String formattedDateTime =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
    tranDateController.text = formattedDateTime;
    super.initState();
  }

  int indexTransactionType = 0;
  int indexWallet = 0;
  int indexTransactionCategoryTypeIncome = 0;
  TextEditingController amountMoneyController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tranDateController = TextEditingController();
  TypeTransactionType typeTransaction = TypeTransactionType();
  // form
  int? idTransactionCategory;
  int? idWallet;
  // image
  XFile? _image;
  File? _imageFile;

  Future<void> _getImageFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      _imageFile = _image != null ? File(_image!.path) : null;
    });
  }

  Future<void> _getImageFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _imageFile = _image != null ? File(_image!.path) : null;
    });
  }

  @override
  void dispose() {
    amountMoneyController.dispose();
    descriptionController.dispose();
    tranDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        TransactionTypeDropdown(
          listTypeTransaction: typeTransaction.listTypeTransaction,
          indexTransactionType: indexTransactionType,
          onChanged: (newValue) {
            setState(() {
              indexTransactionType = typeTransaction.listTypeTransaction
                  .indexWhere((element) => element['typeName'] == newValue);
            });
          },
        ),
        BlocBuilder<TransactionCategoryBloc, TransactionCategoryState>(
          builder: (context, state) {
            switch (indexTransactionType) {
              case 0:
                return Container(
                  child: TransactionCategoryDropdown(
                    transactionCategoryList:
                        state.transactionCategoryInComeList,
                    indexTransactionCategoryTypeIncome:
                        indexTransactionCategoryTypeIncome,
                    onCategoryChanged: (index, categoryId) {
                      setState(() {
                        indexTransactionCategoryTypeIncome = index;
                        idTransactionCategory = categoryId;
                      });
                    },
                  ),
                );
            }
            return SizedBox.shrink();
          },
        ),
        SizedBox(
          height: 12,
        ),
        Icon(
          Icons.arrow_downward_rounded,
          color: Color(0xFF15616D),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocBuilder<TransactionCategoryBloc, TransactionCategoryState>(
            builder: (context, state) {
              switch (indexTransactionType) {
                case 0: // case add income
                  return BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, walletState) {
                      return WalletDropdown(
                        walletList: walletState.wallets,
                        selectedWallet:
                            walletState.wallets[indexWallet].walletName,
                        onChanged: (newValueWallet) {
                          indexWallet = walletState.wallets.indexWhere(
                              (element) =>
                                  element.walletName == newValueWallet);
                          idWallet = walletState.wallets
                              .firstWhere((element) =>
                                  element.walletName == newValueWallet)
                              .walletId;
                        },
                      );
                    },
                  );
              }
              return SizedBox.shrink();
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: AmountTextField(
              amountMoneyController: amountMoneyController,
            )),
        SizedBox(
          height: 12,
        ),
        // Trsndate
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DatePickerField(
              tranDateController: tranDateController,
            )),
        SizedBox(
          height: 12,
        ),

        // image
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ImageSelectionScreen(
            image: _image,
            getImageFromCamera: _getImageFromCamera,
            getImageFromGallery: _getImageFromGallery,
            onViewImage: () {
              if (_image != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Color(0xFF15616D),
                    ),
                    body: Center(
                      child: Image.file(
                        File(_image!.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }));
              }
            },
            onDeleteImage: () {
              if (_imageFile != null) {
                _imageFile!.delete().then((_) {
                  setState(() {
                    _image = null;
                    _imageFile = null;
                  });
                }).catchError((error) {
                  print("Error deleting image file: $error");
                });
              }
            },
          ),
        ),
        SizedBox(
          height: 12,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: DescriptionTextField(
                descriptionController: descriptionController)),
        SizedBox(
          height: 12,
        ),
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            return ActionPopup(
                bottonFirstName: "Cancle",
                bottonSecondeName: "Add",
                bottonFirstNameFunction: () {
                  Navigator.pop(context);
                },
                bottonSecondeNameFunction: () async {
                  switch (indexTransactionType) {
                    case 0:
                      int idTransactionCategoryFormat =
                          int.parse(idTransactionCategory.toString());
                      int idWalletFormat = int.parse(idWallet.toString());
                      double amount = double.parse(amountMoneyController.text);
                      String tranDateFormat =
                          changeFormatter(tranDateController.text);
                      showCircularLoading(context);
                      context.read<TransactionBloc>().add(
                          createTransactionIncome(
                              idTransactionCategoryFormat,
                              idWalletFormat,
                              amount,
                              tranDateFormat,
                              _imageFile,
                              descriptionController.text));
                      context.read<TransactionBloc>().stream.listen((state) {
                        print(
                            "after create income status in transaction card : ${state.incomeStatus}");
                        if (state.incomeStatus == TransactionStatus.loaded) {
                          context.read<WalletBloc>().add(GetAllWallet());
                          context
                              .read<TransactionBloc>()
                              .add(resetIncomeStatus());
                          hideCircularLoading(context);
                          Navigator.pop(context);
                        }
                      });
                      break;
                  }
                });
          },
        )
      ],
    ));
  }

  void showCircularLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ไม่ให้ปิดได้โดยการแตะภายนอก Dialog
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideCircularLoading(BuildContext context) {
    Navigator.of(context).pop();
  }
}
