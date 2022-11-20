import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'core/di/injection.dart';
import 'features/github_page/cubit/github_search_cubit.dart';
import 'index.dart';

GetIt getIt = GetIt.instance;

Future<void> main() async {
  await dotenv.load(fileName: 'env/.env');

  configureInjection();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: BlocProvider(
        create: (_) => getIt<GithubSearchCubit>(),
        child: const GithubPage(),
      ),
    );
  }
}
