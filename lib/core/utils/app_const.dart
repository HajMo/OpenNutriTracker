import 'package:opennutritracker/core/utils/platform_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConst {
  static const userAgentAppName = "OpenNutriTracker";
  static const reportErrorEmail = "opennutritracker-dev@pm.me";
  static const sourceCodeUrl =
      "https://github.com/simonoppowa/OpenNutriTracker";

  static Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getUserAgentString() async {
    final versionNumber = await getVersionNumber();
    final platformName = PlatformHelper.getPlatformName();
    return '$userAgentAppName - $platformName - Version $versionNumber - $sourceCodeUrl';
  }
}
