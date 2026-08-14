import 'package:go_router/go_router.dart';
import '../features/holidays/presentation/screens/home_screen.dart';

/// Application routing configuration using GoRouter
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
