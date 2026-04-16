import 'package:flutter/material.dart';
import 'dart:ui';

class CreatorDashboard extends StatelessWidget {
  const CreatorDashboard({super.key});

  /// 🌀 Hyper-Advanced Quantum Button with Animated Aura
  Widget buildQuantumButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color coreColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Stack(
        children: [
          /// Outer Plasma Glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: coreColor.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: -5,
                  ),
                ],
              ),
            ),
          ),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: coreColor.withOpacity(0.4),
                    width: 0.8,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      coreColor.withOpacity(0.02),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: coreColor.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 25),
                      child: Row(
                        children: [
                          /// Neon Core Icon
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: coreColor.withOpacity(0.5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                              gradient: RadialGradient(
                                colors: [coreColor, coreColor.withOpacity(0.5)],
                              ),
                            ),
                            child: Icon(icon, color: Colors.black, size: 32),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                    shadows: [
                                      Shadow(color: coreColor, blurRadius: 10),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white24, size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030303),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "OMNI-CREATOR OS",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 5,
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.8),
            radius: 1.2,
            colors: [Color(0xFF1A1A1A), Color(0xFF030303)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 100),
          physics: const BouncingScrollPhysics(),
          children: [
            
            /// 🔥 SYNTHETIC INTELLIGENCE (SI)
            const SectionLabel(label: "SYNTHETIC INTELLIGENCE"),
            buildQuantumButton(
              title: "Neural Motion Gen",
              subtitle: "Convert thoughts to full 8K cinematic clips",
              icon: Icons.psychology_outlined,
              coreColor: const Color(0xFF00FFCC),
              onTap: () {},
            ),
            buildQuantumButton(
              title: "Dream-to-Reel AI",
              subtitle: "Generates surreal environments from text",
              icon: Icons.auto_awesome_motion,
              coreColor: const Color(0xFF0095FF),
              onTap: () {},
            ),

            /// 🧪 QUANTUM FABRICATION
            const SectionLabel(label: "QUANTUM FABRICATION"),
            buildQuantumButton(
              title: "Holographic Studio",
              subtitle: "Project yourself into 3D virtual spaces",
              icon: Icons.view_in_ar_sharp,
              coreColor: const Color(0xFFFF00FF),
              onTap: () {},
            ),
            buildQuantumButton(
              title: "Dynamic Deep-Sync",
              subtitle: "Auto-sync lips and body to any audio track",
              icon: Icons.sync_problem_rounded,
              coreColor: const Color(0xFFFFFF00),
              onTap: () {},
            ),

            /// 🧬 BIOMETRIC & AUDIO
            const SectionLabel(label: "NEURAL AUDIO"),
            buildQuantumButton(
              title: "Atmospheric Sound Gen",
              subtitle: "AI creates mood-based immersive 12D music",
              icon: Icons.blur_on_rounded,
              coreColor: const Color(0xFFFF5500),
              onTap: () {},
            ),

            const SizedBox(height: 50),

            /// 🚫 ABSOLUTE BLOCK PROTOCOL
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.red.withOpacity(0.05),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.gpp_maybe_rounded, color: Colors.redAccent, size: 40),
                  SizedBox(height: 15),
                  Text(
                    "MILITARY-GRADE SECURITY",
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Product, News, or Promotional content detected by Neural-Scanner will result in instant MAC-Address Ban.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white30, fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String label;
  const SectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 10),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.2),
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
        ),
      ),
    );
  }
}