import "package:desapv3/controllers/navigation_link.dart";
import "package:desapv3/services/auth_gate.dart";
import "package:desapv3/views/error_page.dart";
import "package:desapv3/views/homepage/landing_page.dart";
import "package:desapv3/views/login/forgotten_password_page.dart";
import "package:desapv3/views/login/login_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/home_sentinel_page.dart";
import "package:desapv3/views/mosquito_home_sentinel/qrcode_generator.dart";
import "package:desapv3/views/mosquito_home_sentinel/qrcode_scanner.dart";
import "package:desapv3/views/mosquito_home_sentinel/sentinel_info_page.dart";
import "package:desapv3/views/register/register_page.dart";
import "package:flutter/material.dart";

Route<dynamic> generateRoute(RouteSettings settings) {
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
      return MaterialPageRoute(builder: (context) => const ForgottenPasswordPage());

    case homeSentinelRoute:
      return MaterialPageRoute(builder: (context) => const HomeSentinelPage());

    case sentinelInfoRoute:
      return MaterialPageRoute(builder: (context) => const SentinelInfoPage());

    case qrCodeScanner:
      return MaterialPageRoute(builder: (context) => const QrcodeScanner());

    case qrCodeGenerator:
      return MaterialPageRoute(builder: (context) => const QrcodeGenerator());

    default:
      return MaterialPageRoute(builder: (context) => const ErrorPage());
  }
}
