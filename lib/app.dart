import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/library/cubit/library_cubit.dart';
import 'features/library/data/library_repository.dart';
import 'features/library/data/library_local_data_source.dart';

class BookReadingTrackerApp extends StatelessWidget {
  const BookReadingTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = LibraryCubit(
          LibraryRepository(LibraryLocalDataSource()),
        );
        cubit.loadLibrary();
        return cubit;
      },
      child: MaterialApp.router(
        title: 'PagePal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        themeMode: ThemeMode.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}