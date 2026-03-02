import 'package:flutter/material.dart';
import 'package:real_time_messaging_platform/common/utils/colors.dart';
import 'package:real_time_messaging_platform/common/widgets/custom_button.dart';
import 'package:real_time_messaging_platform/features/auth/screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Brand header
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [tabColor, accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'RTMP',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Real-Time Messaging Platform',
              style: TextStyle(
                fontSize: 14,
                color: greyColor,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: size.height / 11),
            // Illustration with tinted overlay
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        tabColor.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Image.asset(
                  'assets/bg.png',
                  height: 220,
                  width: 220,
                  color: tabColor,
                  colorBlendMode: BlendMode.srcIn,
                ),
              ],
            ),
            SizedBox(height: size.height / 11),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy.',
                style: TextStyle(
                  color: greyColor,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                text: 'GET STARTED',
                onPressed: () => navigateToLoginScreen(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
