import "package:desapv3/viewmodels/auth_notifier.dart";
import "package:desapv3/viewmodels/navigation_link.dart";
import "package:desapv3/views/homepage/report_management_page.dart";
import "package:desapv3/views/homepage/view_report_page.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import 'package:go_router/go_router.dart';
import "package:desapv3/models/cup.dart";
import "package:desapv3/models/dengue_case.dart";
import "package:desapv3/models/ovitrap.dart";
import "package:desapv3/services/auth_gate.dart";
import "package:desapv3/views/dengue_case/add_dengue_case.dart";
import "package:desapv3/views/dengue_case/dengue_approval_page.dart";
import "package:desapv3/views/dengue_case/dengue_case_detail.dart";
import "package:desapv3/views/dengue_case/dengue_report_page.dart";
import "package:desapv3/views/dengue_case/edit_dengue_case.dart";
import "package:desapv3/views/error_page.dart";
import "package:desapv3/views/historical_map/mosquito_home_map_page.dart";
import "package:desapv3/views/homepage/landing_page.dart";
import "package:desapv3/views/login/forgotten_password_page.dart";
import "package:desapv3/views/login/login_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel/add_cup_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel/add_ovitrap_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel/edit_cup_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel/edit_ovitrap_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel/home_sentinel_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel/sentinel_info_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/qrcode_generator.dart";
import "package:desapv3/views/mosquito_home_sentinel/qrcode_scanner.dart";
import "package:desapv3/views/register/register_page.dart";
import "package:flutter/material.dart";

GoRouter createRoute(AuthNotifier authNotifier) {
  return GoRouter(
    initialLocation: loginRoute,
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final currentPath = state.uri.path;
      final user = authNotifier.user;
      print("PATH: ${currentPath}");
      print("USER: ${user?.uid}");

      if (currentPath == loginRoute) {
        return user != null
            ? '/home'
            : '/login'; // Redirect unauthenticated users
      }

      // if (authNotifier.user != null && authNotifier.user!.emailVerified) {
      //   return '/verification'; // Redirect unverified users
      // }

      if (currentPath != loginRoute && user == null) {
        return '/login'; // Redirect user back to login
      }

      return null; // No page redirection
    },
    routes: [
      // GoRoute(
      //   path: '/auth_routing',
      //   builder: (context, state) => const AuthGate(),
      // ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgotten_password',
        builder: (context, state) => const ForgottenPasswordPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Homepage(),
      ),
      GoRoute(
        path: '/homeSentinel',
        builder: (context, state) => const HomeSentinelPage(),
      ),
      GoRoute(
        path: '/sentinelInfo',
        builder: (context, state) {
          final args = state.extra as SentinelInfoArgument;
          return SentinelInfoPage(args.ovitrapID);
        },
      ),
      GoRoute(
        path: '/qrScanner',
        builder: (context, state) => const QrcodeScanner(),
      ),
      GoRoute(
        path: '/qrGenerator',
        builder: (context, state) {
          final args = state.extra as QrCodeGenArguments;
          return QrcodeGenerator(args.currentCupID!);
        },
      ),
      GoRoute(
        path: '/addOvitrap',
        builder: (context, state) => const AddOvitrapPage(),
      ),
      GoRoute(
        path: '/editOvitrap',
        builder: (context, state) {
          final args = state.extra as EditOvitrapArguments;
          return EditOvitrapPage(args.ovitrap, args.index);
        },
      ),
      GoRoute(
        path: '/addCup',
        builder: (context, state) {
          final args = state.extra as AddCupArguments;
          return AddCupPage(args.ovitrapID);
        },
      ),
      GoRoute(
        path: '/editCup',
        builder: (context, state) {
          final args = state.extra as EditCupArguments;
          return EditCupPage(args.cup);
        },
      ),
      GoRoute(
        path: '/mosquitoMap',
        builder: (context, state) => const MosquitoHomePage(),
      ),
      GoRoute(
        path: '/dengueReport',
        builder: (context, state) => const DengueReport(),
      ),
      GoRoute(
        path: '/dengueApproval',
        builder: (context, state) => const DengueApproval(),
      ),
      GoRoute(
        path: '/addDengueCase',
        builder: (context, state) => const AddDengueCase(),
      ),
      GoRoute(
        path: '/editDengueCase',
        builder: (context, state) {
          final args = state.extra as EditDengueCaseArguments;
          return EditDengueCase(args.dengueCase, args.index);
        },
      ),
      GoRoute(
        path: '/dengueCaseDetail',
        builder: (context, state) {
          final args = state.extra as DengueCaseDetailArguments;
          return DengueCaseDetail(args.dc);
        },
      ),
      GoRoute(
        path: '/reportManagement',
        builder: (context, state) => const ReportManagementPage(),
      ),
      GoRoute(
        path: '/viewReport',
        builder: (context, state) => const ViewReportPage(),
      ),
    ],
  );
}

class EditOvitrapArguments {
  final OviTrap ovitrap;
  final int index;

  EditOvitrapArguments(this.ovitrap, this.index);
}

class SentinelInfoArgument {
  final String ovitrapID;
  SentinelInfoArgument(this.ovitrapID);
}

class AddCupArguments {
  final String ovitrapID;
  AddCupArguments(this.ovitrapID);
}

class EditCupArguments {
  final Cup cup;
  EditCupArguments(this.cup);
}

class QrCodeGenArguments {
  final String? currentCupID;

  QrCodeGenArguments(this.currentCupID);
}

class EditDengueCaseArguments {
  final DengueCase dengueCase;
  final int index;

  EditDengueCaseArguments(this.dengueCase, this.index);
}

class DengueCaseDetailArguments {
  final DengueCase dc;
  DengueCaseDetailArguments(this.dc);
}
