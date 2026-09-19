import 'package:go_router/go_router.dart';
import 'package:page_pal/features/auth/presentation/screens/login_screen.dart';
import 'package:page_pal/features/auth/presentation/screens/signup_screen.dart';
import 'package:page_pal/features/auth/presentation/screens/splash_screen.dart';
import 'package:page_pal/features/explore/models/book_model.dart';
import 'package:page_pal/features/explore/presentation/screens/book_details_screen.dart';
import 'package:page_pal/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:page_pal/features/settings/presentation/screens/settings_screen.dart';

import '../../features/explore/presentation/screens/explore_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
<<<<<<< HEAD
import '../../shared/main_shell.dart';
=======
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
>>>>>>> dev
import 'route_names.dart';


class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
<<<<<<< HEAD
    initialLocation: RouteNames.splash,
=======
    initialLocation: RouteNames.library,
>>>>>>> dev
    routes: [
      // ── Standalone screens (no bottom nav)
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.library,
        name: RouteNames.library,
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // ── Shell route (with bottom nav bar)
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.explore,                    // 👈 MUST BE HERE
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: RouteNames.library,
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Other standalone screens
      GoRoute(
  path: RouteNames.bookDetails,
  builder: (context, state) {
    final book = state.extra as BookModel;
    return BookDetailsScreen(book: book);
  },
),
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}