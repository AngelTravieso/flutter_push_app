import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_app/config/presentation/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select(
          (NotificationsBloc bloc) => Text('${bloc.state.status}'),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                context.read<NotificationsBloc>().requestPermission(),
            icon: const Icon(
              Icons.settings,
            ),
          )
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final notifications =
        context.watch<NotificationsBloc>().state.notifications;

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];

        return ListTile(
          title: Text(notification.title),
          subtitle: Text(notification.body),
          leading: Image.network(
            notification.imageUrl ??
                'https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%2Fimages%3Fk%3Dno%2Bimage%2Bavailable&psig=AOvVaw2BXvVJQAde__0t0HV4GC4I&ust=1720664061170000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCKjAiK2zm4cDFQAAAAAdAAAAABAE',
          ),
        );
      },
    );
  }
}
