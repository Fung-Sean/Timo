import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:timo_test/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

import '../modules/account/bindings/account_binding.dart';
import '../modules/account/views/account_view.dart';
import '../modules/defaultLogin/bindings/default_login_binding.dart';
import '../modules/defaultLogin/views/default_login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/views/onboarding_transportation_view_view.dart';
import '../modules/onboarding/views/onboarding_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //static const INITIAL = Routes.DEFAULT_LOGIN;
  //static const INITIAL = Routes.LOGIN;
  static const INITIAL = Routes.ONBOARDING;

  //check this!
  static const SECOND_PAGE = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.DEFAULT_LOGIN,
      page: () => const DefaultLoginView(),
      binding: DefaultLoginBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const TransportationView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const PreptimeView(),
      binding: OnboardingBinding(),
    ),
  ];
}
