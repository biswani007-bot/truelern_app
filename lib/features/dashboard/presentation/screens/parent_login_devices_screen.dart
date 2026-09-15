import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Parent Login & Devices Screen — PURE FRONTEND ONLY.
///
/// Figma Source of Truth: `Parent(full app)_TreLern`, Frame: `Login & Devices` (Node 104:530).
/// Displays the exact Figma design:
/// - Top App Bar: Back arrow and centered title "TrueLern" (Node 104:582)
/// - Background: Linear gradient (Lavender -> Sky Blue -> White)
/// - Section Page Title: Centered "Login & Devices" and subtitle description (Node 104:532)
/// - Section CURRENT DEVICE (Node 104:537):
///   - Neumorphic phone icon in blue
///   - "Pixel 8 Pro (This device)"
///   - Active green dot and "Active Now"
/// - Section OTHER ACTIVE DEVICES (Node 104:551):
///   - Device 1: iPhone 15 Pro, "Last active: 2 hours ago", trailing sign-out icon
///   - Device 2: MacBook Air, "Last active: Aug 24", trailing sign-out icon
/// - Section Global Action (Node 104:579):
///   - Centered pill button: "Sign out all other devices" in red #BA1A1A
///
/// STRICT RULES:
/// - Zero backend calls / Zero API calls / Pure static frontend
/// - No bottom navigation bar (matching Figma Node 104:530)
class ParentLoginDevicesScreen extends StatelessWidget {
  const ParentLoginDevicesScreen({super.key});

  static const _svgBackArrow = 'assets/icons/device_back_arrow.svg';
  static const _svgPhoneCurrent = 'assets/icons/device_phone_current.svg';
  static const _svgPhoneOther = 'assets/icons/device_phone_other.svg';
  static const _svgLaptop = 'assets/icons/device_laptop.svg';
  static const _svgSignOut = 'assets/icons/device_sign_out.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('parent_login_devices_screen'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3E8FF), // rgb(243, 232, 255)
              Color(0xFFE0F2FE), // rgb(224, 242, 254)
              Color(0xFFFFFFFF), // rgb(255, 255, 255)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar (Node 104:582)
              _buildTopHeader(context),

              // Main Content ScrollView (Node 104:531)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Section - Page Title (Node 104:532)
                          _buildPageTitleSection(),

                          const SizedBox(height: 24),

                          // Current Device Section (Node 104:537)
                          _buildCurrentDeviceSection(),

                          const SizedBox(height: 24),

                          // Other Active Devices Section (Node 104:551)
                          _buildOtherDevicesSection(context),

                          const SizedBox(height: 24),

                          // Section - Global Action (Node 104:579)
                          _buildGlobalActionSection(context),

                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top App Bar matching Figma Node 104:582 & 104:583
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xCCFFFFFF), // rgba(255, 255, 255, 0.8)
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button (Node 104:584)
          InkWell(
            borderRadius: BorderRadius.circular(9999),
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.pop();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                _svgBackArrow,
                width: 16,
                height: 16,
              ),
            ),
          ),

          // Centered Title "TrueLern" (Node 104:588)
          Expanded(
            child: Center(
              child: Text(
                'TrueLern',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 32 / 24,
                  color: const Color(0xFF191C1E),
                ),
              ),
            ),
          ),

          // Symmetry balancing box matching back button width
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  /// Section - Page Title matching Figma Node 104:532
  Widget _buildPageTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'Login & Devices',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 24 / 16,
              color: const Color(0xFF1A1B23),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            'Manage the devices that are currently logged into\nyour account.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              height: 24 / 16,
              color: const Color(0xFF434655),
            ),
          ),
        ),
      ],
    );
  }

  /// Section - Current Device matching Figma Node 104:537
  Widget _buildCurrentDeviceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading 3: CURRENT DEVICE (Node 104:538)
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'CURRENT DEVICE',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.8,
              height: 24 / 16,
              color: const Color(0xFF747686),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Current Device Card (Node 104:540)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(21),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE2E1ED),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Neumorphic Icon Container (Node 104:541)
              _buildNeumorphicBox(
                iconWidget: SvgPicture.asset(
                  _svgPhoneCurrent,
                  width: 17.5,
                  height: 25.67,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 16),

              // Info Column (Node 104:544)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading 4: Pixel 8 Pro (This device) (Node 104:545)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pixel 8 Pro ',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 24 / 16,
                              color: const Color(0xFF1A1B23),
                            ),
                          ),
                          TextSpan(
                            text: '(This device)',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              height: 24 / 16,
                              color: const Color(0xFF434655),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Active Now Row (Node 104:547)
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Active Now',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            height: 24 / 16,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Section - Other Active Devices matching Figma Node 104:551
  Widget _buildOtherDevicesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading 3: OTHER ACTIVE DEVICES (Node 104:552)
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            'OTHER ACTIVE DEVICES',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 0.8,
              height: 24 / 16,
              color: const Color(0xFF747686),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Device 1: iPhone 15 Pro (Node 104:555)
        _buildOtherDeviceCard(
          context: context,
          iconWidget: SvgPicture.asset(
            _svgPhoneOther,
            width: 17.5,
            height: 25.67,
            fit: BoxFit.contain,
          ),
          deviceName: 'iPhone 15 Pro',
          lastActive: 'Last active: 2 hours ago',
          onSignOut: () {
            // Frontend-only interaction
          },
        ),

        const SizedBox(height: 12),

        // Device 2: MacBook Air (Node 104:567)
        _buildOtherDeviceCard(
          context: context,
          iconWidget: SvgPicture.asset(
            _svgLaptop,
            width: 28,
            height: 19.83,
            fit: BoxFit.contain,
          ),
          deviceName: 'MacBook Air',
          lastActive: 'Last active: Aug 24',
          onSignOut: () {
            // Frontend-only interaction
          },
        ),
      ],
    );
  }

  /// Single Other Device Card matching Figma Node 104:555 & 104:567
  Widget _buildOtherDeviceCard({
    required BuildContext context,
    required Widget iconWidget,
    required String deviceName,
    required String lastActive,
    required VoidCallback onSignOut,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E1ED),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Neumorphic Icon Container (Node 104:556 / 104:568)
          _buildNeumorphicBox(iconWidget: iconWidget),
          const SizedBox(width: 16),

          // Device Details (Node 104:559 / 104:571)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    height: 24 / 16,
                    color: const Color(0xFF1A1B23),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  lastActive,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    height: 24 / 16,
                    color: const Color(0xFF747686),
                  ),
                ),
              ],
            ),
          ),

          // Sign out device button (Node 104:564 / 104:576)
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onSignOut,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                _svgSignOut,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Neumorphic square container matching Figma Node 104:541, 104:556, 104:568
  /// size 48x48, rounded 12px, gradient #FFFFFF to #E6E6E6, dual shadow
  Widget _buildNeumorphicBox({required Widget iconWidget}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment(-0.82, -0.57),
          end: Alignment(0.82, 0.57),
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFE6E6E6),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD1D1D1),
            offset: Offset(4, 4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: iconWidget,
    );
  }

  /// Section - Global Action matching Figma Node 104:579 & 104:580
  Widget _buildGlobalActionSection(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(9999),
        onTap: () {
          // Frontend-only interaction
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            'Sign out all other devices',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              height: 24 / 16,
              color: const Color(0xFFBA1A1A),
            ),
          ),
        ),
      ),
    );
  }
}
