
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store/core/app/app_cubit/app_cubit.dart';
import 'package:store/core/app/connectivity_controller.dart';
import 'package:store/core/app/share/share_cubit.dart';
import 'package:store/core/common/screens/no_network_screen.dart';
import 'package:store/core/di/injection_container.dart';
import 'package:store/core/language/app_localizations_setup.dart';
import 'package:store/core/routes/app_routes.dart';
import 'package:store/core/service/shared_pref/pref_keys.dart';
import 'package:store/core/service/shared_pref/shared_pref.dart';
import 'package:store/core/style/theme/app_theme.dart';
import 'package:store/env.variable.dart';
import 'package:store/features/customer/favorites/presentation/cubit/favorites_cubit.dart';

class AsrooStoreApp extends StatelessWidget {
  const AsrooStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectivityController.instance.isConnected,
      builder: (_, value, __) {
        if (value) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => sl<FavoritesCubit>(),
              ),
              BlocProvider(
                create: (context) => sl<ShareCubit>(),
              ),
              BlocProvider(
                create: (context) => sl<AppCubit>()
                  ..changeAppThemeMode(
                    sharedMode: SharedPref().getBoolean(PrefKeys.themeMode),
                  )
                  ..getSavedLanguage(),
              ),
            ],
            child: ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              child: BlocBuilder<AppCubit, AppState>(
                buildWhen: (previous, current) {
                  return previous != current;
                },
                builder: (context, state) {
                  final cubit = context.read<AppCubit>();
                  return MaterialApp(
                    title: 'Asroo Store',
                    debugShowCheckedModeBanner: EnvVariable.instance.debugMode,
                    theme: cubit.isDark ? themeLight() : themeDark(),
                    locale: Locale(cubit.currentLangCode),
                    supportedLocales: AppLocalizationsSetup.supportedLocales,
                    localizationsDelegates:
                        AppLocalizationsSetup.localizationsDelegates,
                    localeResolutionCallback:
                        AppLocalizationsSetup.localeResolutionCallback,
                    builder: (context, widget) {
                      return GestureDetector(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Scaffold(
                          body: Builder(
                            builder: (context) {
                              ConnectivityController.instance.init();
                              return widget!;
                            },
                          ),
                        ),
                      );
                    },
                    navigatorKey: sl<GlobalKey<NavigatorState>>(),
                    onGenerateRoute: AppRoutes.onGenerateRoute,
                    initialRoute: SharedPref()
                                .getString(PrefKeys.accessToken) !=
                            null
                        ? SharedPref().getString(PrefKeys.userRole) != 'admin'
                            ? AppRoutes.mainCustomer
                            : AppRoutes.homeAdmin
                        : AppRoutes.login,
                  );
                },
              ),
            ),
          );
        } else {
          return MaterialApp(
            title: 'No NetWork ',
            debugShowCheckedModeBanner: EnvVariable.instance.debugMode,
            home: const NoNetWorkScreen(),
          );
        }
      },
    );
  }
}
