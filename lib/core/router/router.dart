import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_poc_task/core/router/path_constants.dart';
import 'package:todo_list_poc_task/feature/add_todo/presentation/view/add_todo_page.dart';
import 'package:todo_list_poc_task/feature/profile/profile_screen.dart';
import 'package:todo_list_poc_task/feature/splash/presentation/splash_page.dart';
import 'package:todo_list_poc_task/feature/todo_list/presentation/view/todo_list_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorTodoListKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellTodoList');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final goRouter = GoRouter(
  initialLocation: PathConstants.splash,
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  routes: [
    // Stateful nested navigation based on:
    // https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // the UI shell
        return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTodoListKey,
          routes: [
            // top route inside branch
            GoRoute(
                name: PathConstants.todos,
                path: PathConstants.todos,
                pageBuilder: (context, state) => NoTransitionPage(
                      child: TodoListPage(
                        idFromDeepLink: int.tryParse(
                            state.uri.queryParameters["idFromDeepLink"] ?? ""),
                      ),
                    ),
                routes: [
                  GoRoute(
                      name: PathConstants.addTodo,
                      path: PathConstants.addTodo,
                      pageBuilder: (context, state) => const NoTransitionPage(
                            child: AddTodoPage(),
                          ),
                      routes: []),
                ]),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            // top route inside branch
            GoRoute(
              name: PathConstants.profile,
              path: PathConstants.profile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: PathConstants.splash,
      name: PathConstants.splash,
      pageBuilder: (context, state) => NoTransitionPage(
        child: SplashPage(),
      ),
    )
  ],
);

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 9,
              spreadRadius: 0,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: const Icon(Icons.list),
                  label: AppLocalizations.of(context)!.todos),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: AppLocalizations.of(context)!.profile),
            ],
            currentIndex: navigationShell.currentIndex,
            selectedItemColor: const Color(0xff8C92AC),
            unselectedItemColor: const Color(0xffc7c7c7),
            onTap: _goBranch,
          ),
        ),
      ),
    );
  }
}
