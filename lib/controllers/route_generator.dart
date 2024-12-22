import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/models/cup.dart";
import "package:desapv3/models/locality_case.dart";
import "package:desapv3/services/auth_gate.dart";
import "package:desapv3/views/error_page.dart";
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

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeRoute:
      return MaterialPageRoute(builder: (context) => const Homepage());

    case loginRoute:
      return MaterialPageRoute(builder: (context) => const LoginPage());

    case registerRoute:
      return MaterialPageRoute(builder: (context) => const RegisterPage());

    case authRoute:
      return MaterialPageRoute(builder: (context) => AuthGate());

    case forgottenpasswordRoute:
      return MaterialPageRoute(
          builder: (context) => const ForgottenPasswordPage());

    case homeSentinelRoute:
      return MaterialPageRoute(builder: (context) => const HomeSentinelPage());

    case sentinelInfoRoute:
      return MaterialPageRoute(builder: (context) => SentinelInfoPage(settings.arguments as String));

    case qrCodeScannerRoute:
      return MaterialPageRoute(builder: (context) => const QrcodeScanner());

    case qrCodeGeneratorRoute:
    final args = settings.arguments as QrCodeGenArguments;
      return MaterialPageRoute(builder: (context) => QrcodeGenerator(args.currentCupID!, args.index));

    case addOvitrapRoute:
      return MaterialPageRoute(builder: (context) => const AddOvitrapPage());

    case editOvitrapRoute:
      final args = settings.arguments as EditOvitrapArguments;
      return MaterialPageRoute(
          builder: (context) => EditOvitrapPage(args.ovitrap, args.index));

    case addCupRoute:
      return MaterialPageRoute(builder: (context) => AddCupPage(settings.arguments as String));

    case editCupRoute:
      final args = settings.arguments as EditCupArguments;
      return MaterialPageRoute(
          builder: (context) => EditCupPage(args.cup));

    default:
      return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}

class EditOvitrapArguments {
  final LocalityCase ovitrap;
  final int index;

  EditOvitrapArguments(this.ovitrap, this.index);
}

class EditCupArguments {
  final Cup cup;
  EditCupArguments(this.cup);
}

class QrCodeGenArguments {
  final String? currentCupID;
  final int index;

  QrCodeGenArguments(this.currentCupID, this.index);
}