import 'package:flutter/material.dart';
import 'package:login_by_phonenumber/auth_repo.dart';
import 'package:login_by_phonenumber/bloc/auth_bloc.dart';
import 'package:login_by_phonenumber/dio_settings.dart';

import 'screens/phone_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => DioSettings(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepo(
            dio: RepositoryProvider.of<DioSettings>(context).dio,
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          repo: RepositoryProvider.of<AuthRepo>(context),
        ),
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: PhoneScreen(),
        ),
      ),
    );
  }
}
