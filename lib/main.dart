import 'package:barcode_generator/bloc/barcode_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/read_excel_bloc.dart';
import 'home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarCode Generator',
      routes: {
        '/': (context) => MultiBlocProvider(
              providers: [
                BlocProvider<ReadExcelBloc>(
                  create: (context) => ReadExcelBloc(),
                ),
                BlocProvider<BarcodeBloc>(
                  create: (context) => BarcodeBloc(),
                ),
              ],
              child: const HomePage(),
            ),
      },
    );
  }
}
