/// ===============================
/// FILE: lib/services/upi_service.dart
/// ===============================
library;

import 'package:url_launcher/url_launcher.dart';

class UPIService {

/// 💰 PAY WITH UPI
static Future<void> pay({
required String upiId,
required String name,
required double amount,
}) async {

final uri = Uri.parse(
  "upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR"
);

if (await canLaunchUrl(uri)) {
  await launchUrl(uri);
} else {
  throw "UPI app not found";
}

}
}