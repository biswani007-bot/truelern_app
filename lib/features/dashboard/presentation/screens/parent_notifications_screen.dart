import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_paths.dart';

/// Parent Notifications Screen — 100% visual match to Figma Frame `Notifications` (Node 76:1378).
///
/// Figma File: `Parent(full app)_TreLern`
/// Node ID: `76:1378`
///
/// STRICT RULES:
/// - Pure static frontend only
/// - Zero backend code, zero API calls, zero database calls
/// - Exact Figma layout, spacing, colors, typography, badges, and card borders
class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  String _selectedTab = 'All';

  // Asset paths
  static const String _imgClassGridIcon = 'assets/images/notif_class_grid_icon.png';
  static const String _imgTeacherAvatar = 'assets/images/notif_teacher_avatar.png';
  static const String _svgCalendar = 'assets/icons/notif_calendar.svg';
  static const String _svgBack = 'assets/icons/notif_back.svg';
  static const String _svgMore = 'assets/icons/notif_more.svg';

  final List<String> _tabs = const ['All', 'Classes', 'Assignments', 'Updates'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Scrollable Notification Content
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
                          // Filter Tabs (Node 76:1380)
                          _buildFilterTabs(),

                          const SizedBox(height: 16),

                          // Notification List (Node 76:1392)
                          _buildNotificationList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Header — TopAppBar (Node 76:1450)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopAppBar(),
            ),

            // BottomNavBar (Node 76:1461)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  /// Top App Bar — Node 76:1450
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
              // Button - Back (Node 76:1452)
              InkWell(
                key: const Key('notifications_back_button'),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(AppRoutePaths.parentDashboard);
                  }
                },
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    _svgBack,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),

              // Title: Notifications (Node 76:1456)
              Text(
                'Notifications',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF191C1E),
                  height: 32 / 24,
                ),
              ),

              // Button - More Options (Node 76:1458)
              InkWell(
                key: const Key('notifications_more_button'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('More options'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    _svgMore,
                    width: 4,
                    height: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Filter Tabs Row (Node 76:1380)
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = _selectedTab == tab;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => _selectedTab = tab),
              borderRadius: BorderRadius.circular(9999),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E4ED8) : const Color(0xFFE8E7F3),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
                            blurRadius: 1,
                            offset: Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tab,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? const Color(0xFFCAD3FF) : const Color(0xFF434655),
                    letterSpacing: 0.1,
                    height: 20 / 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Notification List (Node 76:1392)
  Widget _buildNotificationList() {
    final showClasses = _selectedTab == 'All' || _selectedTab == 'Classes';
    final showAssignments = _selectedTab == 'All' || _selectedTab == 'Assignments';
    final showUpdates = _selectedTab == 'All' || _selectedTab == 'Updates';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: LIVE CLASS (Node 76:1393)
        if (showClasses) ...[
          _buildLiveClassCard(),
          const SizedBox(height: 16),
        ],

        // Card 2: ASSIGNMENT (Node 76:1408)
        if (showAssignments) ...[
          _buildAssignmentCard(),
          const SizedBox(height: 16),
        ],

        // Card 3: TEACHER UPDATE / FEEDBACK (Node 76:1421)
        if (showUpdates) ...[
          _buildFeedbackCard(),
          const SizedBox(height: 16),
        ],

        // Card 4: SYSTEM (Node 76:1436)
        if (showUpdates || showClasses) ...[
          _buildSystemCard(),
        ],
      ],
    );
  }

  /// Card 1: LIVE CLASS (Node 76:1393)
  Widget _buildLiveClassCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FF),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            color: Color(0xFF22D3EE),
            width: 4,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container (Node 76:1395)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x1A22D3EE), // rgba(34, 211, 238, 0.1)
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              _imgClassGridIcon,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 16),

          // Content Column (Node 76:1397)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag & Time Row (Node 76:1398)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'LIVE CLASS',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1D4ED8),
                          letterSpacing: 0.5,
                          height: 15 / 10,
                        ),
                      ),
                    ),
                    Text(
                      'Just now',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF434655),
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Heading 3 (Node 76:1403)
                Text(
                  'Your Public Speaking class starts\nin 15 minutes.',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 24 / 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Body text (Node 76:1405)
                Text(
                  'Join early to test your mic and camera\nsetup.',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF434655),
                    height: 20 / 14,
                  ),
                ),

                const SizedBox(height: 12),

                // Action Button (Node 76:1406)
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening Public Speaking class...'),
                        duration: Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0037B1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Join Class',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0.1,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card 2: ASSIGNMENT (Node 76:1408)
  Widget _buildAssignmentCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FF),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            color: Color(0xFFA855F7),
            width: 4,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container (Node 76:1410)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x1AA855F7), // rgba(168, 85, 247, 0.1)
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              _imgClassGridIcon,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 16),

          // Content Column (Node 76:1412)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag & Time Row (Node 76:1413)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'ASSIGNMENT',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFC2410C),
                          letterSpacing: 0.5,
                          height: 15 / 10,
                        ),
                      ),
                    ),
                    Text(
                      '2 hrs ago',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF434655),
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Heading 3 (Node 76:1418)
                Text(
                  'Your Practical Thinking\nassignment is due tomorrow.',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 24 / 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Body text (Node 76:1420)
                Text(
                  'Don\'t forget to submit your final project\nproposal.',
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
    );
  }

  /// Card 3: TEACHER UPDATE / FEEDBACK (Node 76:1421)
  Widget _buildFeedbackCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FF),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(
            color: Color(0xFF0037B1),
            width: 4,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teacher Avatar Circle (Node 76:1423)
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0x330037B1), // rgba(0, 55, 177, 0.2)
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                _imgTeacherAvatar,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Content Column (Node 76:1425)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag & Time Row (Node 76:1426)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'FEEDBACK',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF15803D),
                          letterSpacing: 0.5,
                          height: 15 / 10,
                        ),
                      ),
                    ),
                    Text(
                      'Yesterday',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF434655),
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Heading 3 (Node 76:1431)
                Text(
                  'Sarah left feedback on your latest\nassignment.',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 24 / 16,
                  ),
                ),

                const SizedBox(height: 4),

                // Body text (Node 76:1433)
                Text(
                  '"Great progress! Just a few minor\ntweaks needed in section 2..."',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF434655),
                    height: 20 / 14,
                  ),
                ),

                const SizedBox(height: 12),

                // Action Button: View Feedback (Node 76:1434)
                InkWell(
                  onTap: () {
                    context.go(AppRoutePaths.teacherFeedback);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF747686),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'View Feedback',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0037B1),
                        letterSpacing: 0.1,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card 4: SYSTEM (Node 76:1436)
  Widget _buildSystemCard() {
    return Opacity(
      opacity: 0.75,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFAF8FF),
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            left: BorderSide(
              color: Color(0xFFE2E1ED),
              width: 4,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Icon Container (Node 76:1438)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0x4DE2E1ED), // rgba(226, 225, 237, 0.3)
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                _svgCalendar,
                width: 18,
                height: 20,
              ),
            ),

            const SizedBox(width: 16),

            // Content Column (Node 76:1441)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag & Time Row (Node 76:1442)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'SYSTEM',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF374151),
                            letterSpacing: 0.5,
                            height: 15 / 10,
                          ),
                        ),
                      ),
                      Text(
                        'Oct 24',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF434655),
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Heading 3 (Node 76:1446)
                  Text(
                    'Your class schedule has changed.',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1B23),
                      height: 24 / 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Body text (Node 76:1448)
                  Text(
                    'The Friday workshop has been moved\nto 3:00 PM.',
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

  /// Bottom Navigation Bar — Node 76:1461
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
                    isActive: true, // Node 76:1480 active tab: Profile
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
