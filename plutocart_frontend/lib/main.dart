import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:plutocart/src/app.dart';
import 'package:plutocart/src/blocs/debt_bloc/debt_bloc.dart';
import 'package:plutocart/src/blocs/goal_bloc/goal_bloc.dart';
import 'package:plutocart/src/blocs/graph_bloc/graph_bloc.dart';
import 'package:plutocart/src/blocs/login_bloc/login_bloc.dart';
import 'package:plutocart/src/blocs/page_bloc/page_bloc.dart';
import 'package:plutocart/src/blocs/transaction_bloc/bloc/transaction_bloc.dart';
import 'package:plutocart/src/blocs/transaction_category_bloc/bloc/transaction_category_bloc.dart';
import 'package:plutocart/src/blocs/wallet_bloc/bloc/wallet_bloc.dart';
import 'package:plutocart/src/pages/connection_internet/no_connection_internet.dart';

Future<void> main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        height: 500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/icon/icon_launch.png'),
                height: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text("Please restart application ",
                      style: TextStyle(
                          color: Color(0xFF15616D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto")),
                  Text("or change menu slow down!",
                      style: TextStyle(
                          color: Color(0xFF15616D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto")),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  };
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  HttpOverrides.global = new MyHttpOverrides();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    FlutterNativeSplash.remove();
    runApp(MyWidget());
  });
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isConnected = true;
  @override
  Widget build(BuildContext context) {
    final walletBloc = BlocProvider(create: (context) => WalletBloc());
    final loginBloc = BlocProvider(create: (context) => LoginBloc());
    final transactionCategoryBloc =
        BlocProvider(create: (context) => TransactionCategoryBloc());
    final transactionBloc =
        BlocProvider(create: (context) => TransactionBloc());
    final pageBloc = BlocProvider(create: (context) => PageBloc());
    final goalBloc = BlocProvider(create: (context) => GoalBloc());
    final debtBloc = BlocProvider(create: (context) => DebtBloc());
    final graphBloc = BlocProvider(create: (context) => GraphBloc());
    return MultiBlocProvider(
        providers: [
          walletBloc,
          loginBloc,
          transactionCategoryBloc,
          transactionBloc,
          pageBloc,
          goalBloc,
          debtBloc,
          graphBloc
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(primary: Color(0XFF15616D)),
                textTheme: TextTheme(
                  displayLarge: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: Color(0xFF15616D)),
                )),
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              body: isConnected ? PlutocartApp() : NoConnectionPage(),
            )));
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isConnected = true;
      });
    }
  }

  late StreamSubscription<ConnectivityResult> subscription;

  void initConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {}
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    initConnectivity();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }
}
