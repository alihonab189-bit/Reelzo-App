import 'package:flutter/material.dart';
import '../services/account_type_service.dart';
import '../services/payment_alert_service.dart'; // Import your voice service

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String currentType = "public"; 
  String userId = "user1"; 
  bool isVoiceAlertEnabled = true; // State for Voice Alert

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load current settings from Firebase and Local Storage
  Future<void> _loadSettings() async {
    String type = await AccountTypeService.getAccountType(userId);
    bool voiceStatus = await PaymentAlertService().getAlertStatus();
    setState(() {
      currentType = type;
      isVoiceAlertEnabled = voiceStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          // --- 🛡️ ACCOUNT PRIVACY SECTION ---
          const _SectionHeader(title: "Account Privacy"),
          
          _buildPrivacyTile(
            title: "Private Account",
            subtitle: "Only followers can see your content",
            icon: Icons.lock_outline,
            type: "private",
            activeColor: Colors.orangeAccent,
          ),
          
          _buildPrivacyTile(
            title: "Public Account",
            subtitle: "Everyone can discover your reels",
            icon: Icons.public,
            type: "public",
            activeColor: Colors.greenAccent,
          ),
          
          _buildPrivacyTile(
            title: "Business Account",
            subtitle: "Access to analytics & shop tools",
            icon: Icons.business_center_outlined,
            type: "business",
            activeColor: Colors.blueAccent,
          ),

          const Divider(color: Colors.white10, height: 20),

          // --- 🔊 PAYMENT VOICE ALERT SECTION ---
          const _SectionHeader(title: "Payment Settings"),
          
          SwitchListTile(
            secondary: Icon(
              isVoiceAlertEnabled ? Icons.record_voice_over : Icons.voice_over_off,
              color: isVoiceAlertEnabled ? Colors.pinkAccent : Colors.white38,
            ),
            title: const Text(
              "Voice Payment Alert",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            subtitle: const Text(
              "Announce incoming payments instantly",
              style: TextStyle(color: Colors.white24, fontSize: 11),
            ),
            activeThumbColor: Colors.pinkAccent,
            value: isVoiceAlertEnabled,
            onChanged: (bool value) async {
              await PaymentAlertService().updateAlertStatus(value);
              setState(() {
                isVoiceAlertEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Voice Alert ${value ? 'Enabled' : 'Disabled'} 🔊"),
                  duration: const Duration(seconds: 1),
                  backgroundColor: Colors.pinkAccent,
                ),
              );
            },
          ),

          const Divider(color: Colors.white10, height: 20),

          // --- ⚙️ GENERAL SETTINGS SECTION ---
          const _SectionHeader(title: "General"),
          
          _buildGeneralTile(
            title: "Notifications",
            icon: Icons.notifications_none,
            onTap: () {},
          ),
          
          _buildGeneralTile(
            title: "Change Password",
            icon: Icons.vpn_key_outlined,
            onTap: () {},
          ),

          const SizedBox(height: 20),

          // --- 🚪 LOGOUT ---
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onTap: () {
              // Add Logout Logic
            },
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets Below ---

  Widget _buildPrivacyTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String type,
    required Color activeColor,
  }) {
    bool isSelected = currentType == type;
    return ListTile(
      onTap: () async {
        setState(() => currentType = type);
        await AccountTypeService.updateAccountType(userId, type);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account switched to $type mode ✅"), backgroundColor: Colors.grey[900]),
        );
      },
      leading: Icon(icon, color: isSelected ? activeColor : Colors.white38),
      title: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white24, fontSize: 11)),
      trailing: isSelected 
          ? Icon(Icons.radio_button_checked, color: activeColor) 
          : const Icon(Icons.radio_button_off, color: Colors.white10),
    );
  }

  Widget _buildGeneralTile({required String title, required IconData icon, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 15)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white12, size: 16),
      onTap: onTap,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 15, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.pinkAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }
}