import 'package:flutter/material.dart';
import 'package:plutocart/src/app.dart';
import 'package:plutocart/src/pages/debt/debt.dart';
import 'package:plutocart/src/pages/goal/goal.dart';
import 'package:plutocart/src/pages/graph/graph.dart';
import 'package:plutocart/src/pages/home/home.dart';
import 'package:plutocart/src/pages/login/home_login.dart';
import 'package:plutocart/src/pages/login/sign_in.dart';
import 'package:plutocart/src/pages/login/sign_up.dart';
import 'package:plutocart/src/pages/transaction/transaction.dart';

class AppRoute{
  static const home = 'home';
   static const goal = 'goal';
    static const debt = 'debt';
  static const login = 'login';
  static const transaction = 'transaction';
  static const graph = 'graph';
  static const signUp = 'signUp';
  static const app = 'PlutocartApp';
  static const signIn = 'signIn';

 static get all => <String , WidgetBuilder>{
  home:(context) => const HomePage(),
  transaction:(context) => const TransactionPage(),
  login:(context) => const HomeLogin(),
  signUp:(context) => const SignUp(),
  signIn:((context) => const SignIn()),
  app:(context) =>  PlutocartApp(),
  goal:(context) => const GoalPage(),
  debt:(context) => const DebtPage(),
  graph:(context) => const GraphPage(),
 };
}