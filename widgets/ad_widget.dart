/// ===============================
/// FILE: lib/widgets/ad_widget.dart
/// ===============================
library;

import 'package:flutter/material.dart';
import '../models/ad_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdWidget extends StatelessWidget {
final AdModel ad;

const AdWidget({super.key, required this.ad});

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: () async {
final uri = Uri.parse(ad.link);
if (await canLaunchUrl(uri)) {
await launchUrl(uri);
}
},
child: Card(
elevation: 5,
margin: const EdgeInsets.all(8),
child: Column(
children: [
Image.network(ad.imageUrl, fit: BoxFit.cover),
Padding(
padding: const EdgeInsets.all(8.0),
child: Text(ad.title, style: const TextStyle(fontWeight: FontWeight.bold)),
),
],
),
),
);
}
}