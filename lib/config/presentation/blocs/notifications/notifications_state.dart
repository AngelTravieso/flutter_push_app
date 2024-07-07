part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  // TODO crear el modelo de notificaciones
  final List<dynamic> notifications;

  const NotificationsState({
    this.status = AuthorizationStatus.notDetermined,
    this.notifications = const [],
  });

  @override
  List<Object> get props => [
        status,
        notifications,
      ];

  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<dynamic>? notifications,
  }) =>
      NotificationsState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
      );
}

final class NotificationsInitial extends NotificationsState {}