import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/domain/entities/push_message.dart';

import 'package:push_app/firebase_options.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

// Escuchar notificaciones onBackground
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationsStatusChanged>(_notificationsStatusChanged);

    // Ejecutar metodos en el contructor (es parecido a cuando lo llamo en el constructor en riverpod)
    // Apenas la aplicacion se llama lanzar el prompt para los permisos
    // requestPermission();

    // Verificar estado de las notificaciones
    _initialStatusCheck();

    // Listener para notificaciones foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationsStatusChanged(
      NotificationsStatusChanged event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(
      status: event.status,
    ));

    // Obtener el token
    _getFCMToken();
  }

  // Con esto verifico el status de los permisos para notificaciones
  void _initialStatusCheck() async {
    // Determinar el estado actual
    final settings = await messaging.getNotificationSettings();

    // El cambio del status es sincrono
    add(NotificationsStatusChanged(settings.authorizationStatus));

    // Obtener el token
    // _getFCMToken();

    // Se tiene un token especifico, esto es para enviar a un dispositivo/usuario en especifico
    /**
     * un usuario puede tener varios dispostivos
     * angeltraviesoc@gmail.com {
     * token1
     * token2
     * token3
     * }
     */
  }

  // Esto obtiene el token unico del dispositivo
  void _getFCMToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();

    print(token);
  }

  // Escuchar mensajes onForeground
  void _handleRemoteMessage(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification == null) return;

    final notification = PushMessage(
      messageId:
          message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
      title: message.notification!.title ?? '',
      body: message.notification!.body ?? '',
      sentDate: message.sentTime ?? DateTime.now(),
      data: message.data,
      imageUrl: Platform.isAndroid
          ? message.notification!.android?.imageUrl
          : message.notification!.apple?.imageUrl,
    );

    print('Message also contained a notification: $notification');
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handleRemoteMessage);
  }

  void requestPermission() async {
    // Aca pido el permiso
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    add(NotificationsStatusChanged(settings.authorizationStatus));
    // Obtener el token
    // _getFCMToken();
  }
}
