import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routes/route_names.dart';
import '../core/widgets/gradient_background.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFor(location);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: GradientBackground(child: child),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: (i) {
              switch (i) {
                case 0:
                  context.go(RouteNames.home);
                  break;
                case 1:
                  context.go(RouteNames.explore);
                  break;
                case 2:
                  context.go(RouteNames.library);
                  break;
                case 3:
                  context.go(RouteNames.profile);
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore_rounded),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books_outlined),
                activeIcon: Icon(Icons.library_books_rounded),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _indexFor(String location) {
    if (location.startsWith(RouteNames.explore)) return 1;
    if (location.startsWith(RouteNames.library)) return 2;
    if (location.startsWith(RouteNames.profile)) return 3;
    return 0;
  }
}