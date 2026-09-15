import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_paths.dart';
import '../widgets/parent_hamburger_drawer.dart';

/// Parent Messages Screen — 100% visual match to Figma Frame `Messages` (Node 76:1150).
///
/// Figma File: `Parent(full app)_TreLern`
/// Node ID: `76:1150`
///
/// STRICT RULES:
/// - Pure static frontend only
/// - Zero backend code, zero API calls, zero database calls
/// - Exact Figma layout, spacing, colors, typography, badges, and avatars
class ParentMessagesScreen extends StatefulWidget {
  const ParentMessagesScreen({super.key});

  @override
  State<ParentMessagesScreen> createState() => _ParentMessagesScreenState();
}

class _ParentMessagesScreenState extends State<ParentMessagesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _allRead = false;

  // Asset constants
  static const String _imgMsSarahAvatar = 'assets/images/ms_sarah_avatar.png';
  static const String _imgMsJenkinsAvatar = 'assets/images/ms_jenkins_avatar.png';
  static const String _imgLogo = 'assets/images/truelern_top_logo.png';

  static const String _svgMarkRead = 'assets/icons/msg_mark_read.svg';
  static const String _svgBadgeMic = 'assets/icons/msg_badge_mic.svg';
  static const String _svgSupportHeadset = 'assets/icons/msg_support_headset.svg';
  static const String _svgBadgeBook = 'assets/icons/msg_badge_book.svg';
  static const String _svgAllCaughtUp = 'assets/icons/msg_all_caught_up.svg';
  static const String _svgHamburger = 'assets/icons/msg_top_hamburger.svg';
  static const String _svgBell = 'assets/icons/msg_top_bell.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ParentHamburgerDrawer(
        activeItem: 'Messages',
        onTabSelected: (index) {
          Navigator.of(context).pop();
          switch (index) {
            case 0:
              context.go(AppRoutePaths.parentDashboard);
              break;
            case 1:
              context.go(AppRoutePaths.parentClasses);
              break;
            case 2:
              context.go(AppRoutePaths.parentAssignments);
              break;
            case 3:
              context.go(AppRoutePaths.parentProfile);
              break;
          }
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.8, -0.9),
            end: Alignment(0.8, 0.9),
            colors: [
              Color(0xFFF3E8FF), // rgb(243, 232, 255)
              Color(0xFFE0F2FE), // rgb(224, 242, 254)
              Color(0xFFFFFFFF), // rgb(255, 255, 255)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Scrollable Main Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 80, // Clearance for top app bar (64px + 16px)
                    bottom: 100, // Clearance for bottom navigation bar
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 768),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),

                            // Page Title & Mark all read button (Node 76:1152)
                            _buildHeaderRow(),

                            const SizedBox(height: 24),

                            // Message 1 (Unread) — Node 76:1160
                            _buildSarahMessageCard(),

                            const SizedBox(height: 12),

                            // Message 2 (Support) — Node 76:1179
                            _buildSupportMessageCard(),

                            const SizedBox(height: 12),

                            // Message 3 (Read) — Node 76:1192
                            _buildJenkinsMessageCard(),

                            const SizedBox(height: 8),

                            // End of List State — Node 76:1210
                            _buildEndOfListState(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Header — TopAppBar (Node 76:1216)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopAppBar(),
              ),

              // BottomNavBar (Node 76:1225)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Top App Bar — Node 76:1216
  Widget _buildTopAppBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            color: Color(0xCCFAF8FF), // rgba(250, 248, 255, 0.8)
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Button - Menu (Node 76:1217)
              InkWell(
                key: const Key('messages_menu_button'),
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    _svgHamburger,
                    width: 18,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1A1B23),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // Brand Logo (Node 76:1220)
              Image.asset(
                _imgLogo,
                width: 120,
                height: 41,
                fit: BoxFit.contain,
              ),

              // Button - Notifications (Node 76:1221)
              InkWell(
                key: const Key('messages_notification_button'),
                onTap: () => context.go(AppRoutePaths.notifications),
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        _svgBell,
                        width: 16,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0037B1),
                          BlendMode.srcIn,
                        ),
                      ),
                      // Red unread badge dot
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color(0xFFBA1A1A),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Page Title Row (Node 76:1152)
  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Title "Messages" (Node 76:1154)
        Text(
          'Messages',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1B23),
            height: 36 / 28,
          ),
        ),

        // "Mark all read" button (Node 76:1155)
        InkWell(
          key: const Key('mark_all_read_button'),
          onTap: () {
            setState(() => _allRead = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All messages marked as read'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  _svgMarkRead,
                  width: 16.4,
                  height: 9,
                ),
                const SizedBox(width: 4),
                Text(
                  'Mark all read',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0037B1),
                    letterSpacing: 0.1,
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Article - Message 1 (Unread) — Node 76:1160
  Widget _buildSarahMessageCard() {
    final isUnread = !_allRead;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Left blue unread accent indicator (Node 76:1161)
            if (isUnread)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 4,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0037B1),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(9999),
                        bottomRight: Radius.circular(9999),
                      ),
                    ),
                  ),
                ),
              ),

            // Inner card content
            Padding(
              padding: const EdgeInsets.fromLTRB(29, 21, 21, 21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with Track Badge (Node 76:1163)
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE2E1ED),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x0D000000),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              _imgMsSarahAvatar,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Badge: cyan circle with microphone (Node 76:1165)
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22D3EE),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0D000000),
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              _svgBadgeMic,
                              width: 7,
                              height: 9.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Text and Details Content (Node 76:1168)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row: Name & Timestamp (Node 76:1169)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Ms. Sarah',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1A1B23),
                                height: 24 / 16,
                              ),
                            ),
                            Text(
                              '2m ago',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF0037B1),
                                height: 16 / 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Track Badge: COMMUNICATION (Node 76:1175)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x1A22D3EE), // rgba(34, 211, 238, 0.1)
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'COMMUNICATION',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF22D3EE),
                              letterSpacing: 0.5,
                              height: 16 / 10,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Message Text (Node 76:1178)
                        Text(
                          'Great work in today\'s class. Keep it up!',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1B23),
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Article - Message 2 (Support) — Node 76:1179
  Widget _buildSupportMessageCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 21, 21, 21),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headset Support Avatar (Node 76:1181)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E7F3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0x4DE2E1ED),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                _svgSupportHeadset,
                width: 20,
                height: 18,
              ),
            ),

            const SizedBox(width: 16),

            // Content (Node 76:1184)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Name & Timestamp (Node 76:1185)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TrueLern Support',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1B23),
                          height: 24 / 16,
                        ),
                      ),
                      Text(
                        '1h ago',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF747686),
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Message Text (Node 76:1191)
                  Text(
                    'Your demo booking is confirmed. See you soon!',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF434655),
                      height: 20 / 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Article - Message 3 (Read) — Node 76:1192
  Widget _buildJenkinsMessageCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(29, 21, 21, 21),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar with Track Badge (Node 76:1194)
            SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE2E1ED),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _imgMsJenkinsAvatar,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Badge: teal circle with open book (Node 76:1196)
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B8A6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        _svgBadgeBook,
                        width: 11,
                        height: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Content (Node 76:1199)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Name & Timestamp (Node 76:1200)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ms. Jenkins',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1B23),
                          height: 24 / 16,
                        ),
                      ),
                      Text(
                        'Yesterday',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF747686),
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Track Badge: JUNIOR FOUNDATION (Node 76:1206)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x1A14B8A6), // rgba(20, 184, 166, 0.1)
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'JUNIOR FOUNDATION',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF14B8A6),
                        letterSpacing: 0.5,
                        height: 16 / 10,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Message Text (Node 76:1209)
                  Text(
                    'Don\'t forget to upload your blocks assignment by Friday.',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF434655),
                      height: 20 / 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// End of List State — Node 76:1210
  Widget _buildEndOfListState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            SvgPicture.asset(
              _svgAllCaughtUp,
              width: 36,
              height: 36,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'re all caught up!',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF747686),
                letterSpacing: 0.1,
                height: 20 / 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation Bar — Node 76:1225
  Widget _buildBottomNavBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xCCFAF8FF), // rgba(250, 248, 255, 0.8)
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                children: [
                  _buildNavItem(
                    label: 'Home',
                    icon: Icons.home_outlined,
                    isActive: false,
                    onTap: () => context.go(AppRoutePaths.parentDashboard),
                  ),
                  _buildNavItem(
                    label: 'My Classes',
                    icon: Icons.school_outlined,
                    isActive: false,
                    onTap: () => context.go(AppRoutePaths.parentClasses),
                  ),
                  _buildNavItem(
                    label: 'Assignments',
                    icon: Icons.assignment_outlined,
                    isActive: false,
                    onTap: () => context.go(AppRoutePaths.parentAssignments),
                  ),
                  _buildNavItem(
                    label: 'Profile',
                    icon: Icons.person_rounded,
                    isActive: true, // Node 76:1244 active tab: Profile
                    onTap: () => context.go(AppRoutePaths.parentProfile),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final color = isActive ? const Color(0xFF0037B1) : const Color(0xFF434655);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0xFF0037B1).withValues(alpha: 0.08),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.hankenGrotesk(
                color: color,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
