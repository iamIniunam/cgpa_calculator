import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppImages {
  AppImages._();

  static AssetImage appLogo = const AssetImage('assets/images/logo.png');
  static AssetImage sampleProfileImage =
      const AssetImage('assets/images/jcole.png');

  // SVGS

  static SvgPicture svgGoogleLogo =
      SvgPicture.asset('assets/svgs/google_logo.svg');
}
