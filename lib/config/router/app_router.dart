import 'package:go_router/go_router.dart';
import 'package:push_app/config/presentation/screens/details_screens.dart';
import 'package:push_app/config/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) => DetailsScreens(
        pushMessageId: state.pathParameters['messageId'] ?? '',
      ),
    ),
  ],
);
