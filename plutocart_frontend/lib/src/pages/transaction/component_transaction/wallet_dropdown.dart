import 'package:flutter/material.dart';
import 'package:plutocart/src/models/wallet/wallet_model.dart';

class WalletDropdown extends StatefulWidget {
  final List<Wallet> walletList;
  final Function(String?) onChanged;
  final GlobalKey? selectKey;
   final bool? isValue;
   final String ? walleId;

  const WalletDropdown(
      {Key? key,
      required this.walletList,
      required this.onChanged,  this.selectKey , this.isValue , this.walleId})
      : super(key: key);

  @override
  _WalletDropdownState createState() => _WalletDropdownState();
}

class _WalletDropdownState extends State<WalletDropdown> {
  bool isWalletSelected = false;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      key: widget.selectKey,
      value: widget.isValue == false ? null : widget.walleId,
      menuMaxHeight: MediaQuery.of(context).size.height * 0.4,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF15616D)),
      decoration: InputDecoration(
        labelText: "Choose Wallet",
        labelStyle: TextStyle(
            color: isWalletSelected || widget.isValue == true ? Color(0xFF1A9CB0) : Color(0XFFDD0000),
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: isWalletSelected || widget.isValue == true  ? Color(0xFF15616D) : Color(0XFFDD0000)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(
              color: isWalletSelected  || widget.isValue == true ? Color(0xFF15616D) : Color(0XFFDD0000)),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select an item';
        }
        return null;
      },
      items: widget.walletList.map((wallet) {
        return DropdownMenuItem<String>(
          value: wallet.walletId.toString(),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image(
                  image: AssetImage('assets/icon/wallet_icon.png'),
                  width: MediaQuery.of(context).size.width * 0.1,   
                ),
              ),
              Text(
                wallet.walletName,
                style: TextStyle(
                  color: Color(0xFF15616D),
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          isWalletSelected = true;
        });
        widget.onChanged(value);
      },
    );
  }
}
