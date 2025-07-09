import "package:desapv3/viewmodels/navigation_link.dart";
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
      return MaterialPageRoute(
          builder: (context) => SentinelInfoPage(settings.arguments as String));

    case qrCodeScannerRoute:
      return MaterialPageRoute(builder: (context) => const QrcodeScanner());

    case qrCodeGeneratorRoute:
      final args = settings.arguments as QrCodeGenArguments;
      return MaterialPageRoute(
          builder: (context) => QrcodeGenerator(args.currentCupID!));

    case addOvitrapRoute:
      return MaterialPageRoute(builder: (context) => const AddOvitrapPage());

    case editOvitrapRoute:
      final args = settings.arguments as EditOvitrapArguments;
      return MaterialPageRoute(
          builder: (context) => EditOvitrapPage(args.ovitrap, args.index));

    case addCupRoute:
      return MaterialPageRoute(
          builder: (context) => AddCupPage(settings.arguments as String));

    case editCupRoute:
      final args = settings.arguments as EditCupArguments;
      return MaterialPageRoute(builder: (context) => EditCupPage(args.cup));

    case mosquitoMapRoute:
      return MaterialPageRoute(builder: (context) => const MosquitoHomePage());

    case dengueReportRoute:
      return MaterialPageRoute(builder: (context) => const DengueReport());

    case dengueApprovalRoute:
      return MaterialPageRoute(builder: (context) => const DengueApproval());

    case addDengueCaseRoute:
      return MaterialPageRoute(builder: (context) => const AddDengueCase());

    case editDengueCaseRoute:
      final args = settings.arguments as EditDengueCaseArguments;
      return MaterialPageRoute(
          builder: (context) => EditDengueCase(args.dengueCase, args.index));

    case dengueCaseDetailRoute:
      final args = settings.arguments as DengueCaseDetailArguments;
      return MaterialPageRoute(builder: (context) => DengueCaseDetail(args.dc));

    default:
      return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}

class EditOvitrapArguments {
  final OviTrap ovitrap;
  final int index;

  EditOvitrapArguments(this.ovitrap, this.index);
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
