import 'package:url_launcher/url_launcher.dart';

/// Opens [uri] with the platform launcher.
///
/// Tries [LaunchMode.externalNonBrowserApplication] first, then
/// [LaunchMode.externalApplication], and finally [LaunchMode.platformDefault].
/// Returns `true` when an attempt succeeds and `false` when every attempt
/// fails or throws.
Future<bool> openLink(Uri uri) async {
  var success = false;
  try {
    success = await launchUrl(
      uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );
  } catch (_) {
    success = false;
  }
  if (!success) {
    try {
      success = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      success = false;
    }
  }
  if (!success) {
    try {
      success = await launchUrl(uri, mode: LaunchMode.platformDefault);
    } catch (_) {
      success = false;
    }
  }
  return success;
}
