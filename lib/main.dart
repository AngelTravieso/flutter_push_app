import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:push_app/config/router/app_router.dart';

import 'package:push_app/config/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Escuchar notificaciones onBackground
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Asegurar que Firebase esta inicializado
  await NotificationsBloc.initializeFCM();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotificationsBloc(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Material App',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
    );
  }
}
