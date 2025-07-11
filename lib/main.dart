import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap_invest_assignment/bloc/company_cubit.dart';
import 'package:tap_invest_assignment/bloc/company_details_cubit.dart';
import 'package:tap_invest_assignment/repository/company_repository.dart';
import 'package:tap_invest_assignment/screens/splash_screen.dart';
import 'package:tap_invest_assignment/utils/custom_theme.dart';
import 'package:tap_invest_assignment/utils/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CompanyCubit(CompanyRepositoryImpl()),
        ),
        BlocProvider(
            create: (_) => CompanyDetailsCubit(CompanyRepositoryImpl()))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: CustomTheme.lightTheme,
        home: const SplashScreen());
  }
}
