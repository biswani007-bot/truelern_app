import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_paths.dart';
import '../widgets/parent_hamburger_drawer.dart';

/// Parent Learning Progress Screen — PURE STATIC FRONTEND ONLY.
///
/// Figma Source of Truth:
/// - File: `Parent(full app)_TreLern`
/// - Screen: `Learning Progress (New)` (Node `76:3053`, 390 × 1305.26px)
///
/// STRICT RULES:
/// - NO backend calls / NO API calls / NO database / NO network requests.
/// - Static frontend only, works 100% offline.
/// - Exact visual reproduction of Figma frame 76:3053.
/// - Single bottom navigation bar matching Figma Node 76:3054.
class ParentLearningProgressScreen extends StatefulWidget {
  const ParentLearningProgressScreen({super.key});

  @override
  State<ParentLearningProgressScreen> createState() =>
      _ParentLearningProgressScreenState();
}

class _ParentLearningProgressScreenState
    extends State<ParentLearningProgressScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Assets extracted directly from Figma Node 76:3053
  static const _logo = 'assets/images/learning_progress_logo.png';
  static const _iconSpeech = 'assets/images/learning_progress_icon_speech.png';
  static const _iconCommunication =
      'assets/images/learning_progress_icon_communication.png';
  static const _iconBrain = 'assets/images/learning_progress_icon_brain.png';
  static const _iconPractical =
      'assets/images/learning_progress_icon_practical.png';

  static const _svgDrawer = 'assets/icons/learning_progress_drawer.svg';
  static const _svgBell = 'assets/icons/learning_progress_bell.svg';
  static const _svgNavHome = 'assets/icons/learning_progress_home.svg';
  static const _svgNavClasses = 'assets/icons/learning_progress_classes.svg';
  static const _svgNavAssignment =
      'assets/icons/learning_progress_assignment.svg';
  static const _svgNavProfile = 'assets/icons/learning_progress_profile.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ParentHamburgerDrawer(activeItem: 'Learning Progress'),
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.7, -0.7),
            end: Alignment(0.7, 0.7),
            colors: [
              Color(0xFFF3E8FF), // rgb(243, 232, 255) 0%
              Color(0xFFE0F2FE), // rgb(224, 242, 254) 50%
              Color(0xFFFFFFFF), // rgb(255, 255, 255) 100%
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // ── Top App Bar (Node 76:3077) ─────────────────────────
              _buildTopAppBar(context),

              // ── Scrollable Content (Node 76:3086) ───────────────────
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('learning_progress_scroll_view'),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),

                            // ── Header Section (Node 76:3087) ───────────────
                            _buildHeaderSection(),

                            const SizedBox(height: 24),

                            // ── Skill Cards Grid (Node 76:3101) ─────────────
                            _buildSkillCards(),

                            const SizedBox(height: 16),

                            // ── View Detailed Report Button (Node 76:3150) ──
                            _buildDetailedReportButton(),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Single Bottom Navigation Bar (Node 76:3054) ─────────
              _buildBottomNavBar(context),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top App Bar (Node 76:3077) ───────────────────────────────────────────
  Widget _buildTopAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hamburger Drawer Button (Node 76:3078)
              InkWell(
                key: const Key('learning_progress_drawer_button'),
                borderRadius: BorderRadius.circular(9999),
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      _svgDrawer,
                      width: 18,
                      height: 12,
                    ),
                  ),
                ),
              ),

              // TrueLern Logo (Node 76:3082)
              Image.asset(
                _logo,
                width: 132,
                height: 45.26,
                fit: BoxFit.contain,
              ),

              // Bell Notification Button (Node 76:3083)
              InkWell(
                key: const Key('learning_progress_bell_button'),
                borderRadius: BorderRadius.circular(9999),
                onTap: () => context.push(AppRoutePaths.notifications),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      _svgBell,
                      width: 16,
                      height: 20,
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

  // ── Header Section (Node 76:3087) ─────────────────────────────────────────
  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "My Progress" Heading (Node 76:3089)
        Text(
          'My Progress',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1B23),
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 8),

        // Track Pill (Node 76:3090)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF22D3EE).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            'Public Speaking & Communication',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF22D3EE),
              height: 24 / 16,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Overall Progress Dial Card (Node 76:3092)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 40,
            bottom: 24,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000), // rgba(0,0,0,0.04)
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: SizedBox(
              width: 248,
              height: 248,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circular dial gauge (Node 76:3093)
                  CustomPaint(
                    size: const Size(248, 248),
                    painter: const _MasteryDialPainter(),
                  ),

                  // Center Text Container (Node 76:3096)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '72%',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0037B1),
                          height: 24 / 16,
                        ),
                      ),
                      Text(
                        'Overall Mastery',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF434655),
                          height: 24 / 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Skill Cards Grid (Node 76:3101) ───────────────────────────────────────
  Widget _buildSkillCards() {
    return Column(
      children: [
        // Card 1: Public Speaking (Node 76:3102)
        _buildSkillCard(
          key: const Key('skill_card_public_speaking'),
          title: 'Public Speaking',
          level: 'Level 3',
          percentage: '78%',
          progressValue: 0.78,
          accentColor: const Color(0xFF22D3EE),
          iconAsset: _iconSpeech,
          iconBgColor: const Color(0xFF22D3EE).withValues(alpha: 0.1),
        ),
        const SizedBox(height: 12),

        // Card 2: Communication (Node 76:3114)
        _buildSkillCard(
          key: const Key('skill_card_communication'),
          title: 'Communication',
          level: 'Level 3',
          percentage: '71%',
          progressValue: 0.71,
          accentColor: const Color(0xFF22D3EE),
          iconAsset: _iconCommunication,
          iconBgColor: const Color(0xFF22D3EE).withValues(alpha: 0.1),
        ),
        const SizedBox(height: 12),

        // Card 3: Emotional Intelligence (Node 76:3126)
        _buildSkillCard(
          key: const Key('skill_card_emotional_intelligence'),
          title: 'Emotional Intelligence',
          level: 'Level 2',
          percentage: '64%',
          progressValue: 0.64,
          accentColor: const Color(0xFFFB7185),
          iconAsset: _iconBrain,
          iconBgColor: const Color(0xFFFB7185).withValues(alpha: 0.1),
        ),
        const SizedBox(height: 12),

        // Card 4: Practical Thinking (Node 76:3138)
        _buildSkillCard(
          key: const Key('skill_card_practical_thinking'),
          title: 'Practical Thinking',
          level: 'Level 2',
          percentage: '58%',
          progressValue: 0.58,
          accentColor: const Color(0xFFA855F7),
          iconAsset: _iconPractical,
          iconBgColor: const Color(0xFFA855F7).withValues(alpha: 0.1),
        ),
      ],
    );
  }

  Widget _buildSkillCard({
    required Key key,
    required String title,
    required String level,
    required String percentage,
    required double progressValue,
    required Color accentColor,
    required String iconAsset,
    required Color iconBgColor,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0,0,0,0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: accentColor,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.only(
            left: 20, // 20px + 4px border = 24px per Figma
            right: 20,
            top: 20,
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon + Title/Subtitle + Percentage
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 56x56 Icon Container
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Center(
                      child: Image.asset(
                        iconAsset,
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title & Level
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1B23),
                            height: 24 / 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          level,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF434655),
                            height: 24 / 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Percentage
                  Text(
                    percentage,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                      height: 24 / 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Linear Progress Track (Node 76:3112)
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(9999),
                ),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: progressValue.clamp(0.0, 1.0),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(9999),
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

  // ── View Detailed Report Button (Node 76:3151) ───────────────────────────
  Widget _buildDetailedReportButton() {
    return Center(
      child: InkWell(
        key: const Key('view_detailed_report_button'),
        borderRadius: BorderRadius.circular(9999),
        onTap: () {
          // Static frontend action — user feedback or preview
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0037B1),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000), // rgba(0,0,0,0.10)
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color(0x1A000000), // rgba(0,0,0,0.10)
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'View Detailed Report',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 24 / 16,
            ),
          ),
        ),
      ),
    );
  }

  // ── Single Bottom Navigation Bar (Node 76:3054) ───────────────────────────
  Widget _buildBottomNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.9),
            border: Border(
              top: BorderSide(
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000), // rgba(0,0,0,0.04)
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            left: 24.75,
            right: 20.75,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. Home Tab (Active) (Node 76:3055)
              _buildNavBarItem(
                iconSvg: _svgNavHome,
                iconWidth: 16,
                iconHeight: 18,
                label: 'Home',
                isActive: true,
                activeColor: const Color(0xFF0037B1),
                inactiveColor: const Color(0xFF747686),
                onTap: () => context.go(AppRoutePaths.parentDashboard),
              ),

              // 2. My Classes Tab (Node 76:3062)
              _buildNavBarItem(
                iconSvg: _svgNavClasses,
                iconWidth: 22,
                iconHeight: 22,
                label: 'My Classes',
                isActive: false,
                activeColor: const Color(0xFF0037B1),
                inactiveColor: const Color(0xFF747686),
                onTap: () => context.go(AppRoutePaths.parentClasses),
              ),

              // 3. Assignment Tab (Node 76:3067)
              _buildNavBarItem(
                iconSvg: _svgNavAssignment,
                iconWidth: 18,
                iconHeight: 24,
                label: 'Assignment',
                isActive: false,
                activeColor: const Color(0xFF0037B1),
                inactiveColor: const Color(0xFF747686),
                onTap: () => context.go(AppRoutePaths.parentAssignments),
              ),

              // 4. Profile Tab (Node 76:3072)
              _buildNavBarItem(
                iconSvg: _svgNavProfile,
                iconWidth: 16,
                iconHeight: 20,
                label: 'Profile',
                isActive: false,
                activeColor: const Color(0xFF0037B1),
                inactiveColor: const Color(0xFF475569),
                onTap: () => context.go(AppRoutePaths.parentProfile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required String iconSvg,
    required double iconWidth,
    required double iconHeight,
    required String label,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    final color = isActive ? activeColor : inactiveColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconSvg,
              width: iconWidth,
              height: iconHeight,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                color: color,
                height: 16 / 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the 248x248 Overall Mastery Dial gauge.
///
/// Draws:
/// - Background track: #F1F5F9 ring (stroke width 26.18)
/// - 4 curved rounded segments (#0037B1, stroke width 19.29, StrokeCap.round)
///   spanning 72% overall circumference matching Figma Node 76:3093.
class _MasteryDialPainter extends CustomPainter {
  const _MasteryDialPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // Diameter = 219.28, radius = 109.64
    final radius = (size.width - 26.1778) / 2;

    // 1. Background full circular ring
    final bgPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26.1778;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. 4 rounded pill segments in blue (#0037B1)
    final bluePaint = Paint()
      ..color = const Color(0xFF0037B1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 19.2889
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // 72% across 4 segments = 18% (64.8°) per segment, with 25.2° gap
    const sweep = 64.8 * math.pi / 180;

    // Segment centers: Top (270°), Right (0°), Bottom (90°), Left (180°)
    const topStart = (270 - 32.4) * math.pi / 180;
    const rightStart = (-32.4) * math.pi / 180;
    const bottomStart = (90 - 32.4) * math.pi / 180;
    const leftStart = (180 - 32.4) * math.pi / 180;

    canvas.drawArc(rect, topStart, sweep, false, bluePaint);
    canvas.drawArc(rect, rightStart, sweep, false, bluePaint);
    canvas.drawArc(rect, bottomStart, sweep, false, bluePaint);
    canvas.drawArc(rect, leftStart, sweep, false, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
