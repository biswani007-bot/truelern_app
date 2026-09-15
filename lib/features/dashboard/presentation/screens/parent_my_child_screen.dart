import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_paths.dart';

/// Parent My Child Screen — PURE FRONTEND ONLY.
///
/// Figma Source of Truth: `Parent(full app)_TreLern`, Frame: `My children` (Node 76:962).
/// Displays the exact Figma design:
/// - TopAppBar with Back button, TrueLern logo, and Trailing icon
/// - Title "My Child" and subtitle "Select a profile to view their learning journey."
/// - Gradient background (Lavender -> Sky Blue -> White)
/// - Child Card 1: Mia (Cyan accent, 72% Overall Progress, 94% Attendance, VIEW CHILD ->)
/// - Child Card 2: Alex (Purple accent, 45% Overall Progress, 88% Attendance, VIEW CHILD ->)
/// - Add Child Card: Dashed rounded border, + button, "ADD CHILD"
///
/// STRICT RULES:
/// - Zero backend calls / Zero API calls / Pure static frontend
/// - Single bottom navigation bar provided by ParentShellScreen
class ParentMyChildScreen extends StatelessWidget {
  const ParentMyChildScreen({super.key});

  static const _imgAvatarMia = 'assets/images/avatar_mia.png';
  static const _imgAvatarAlex = 'assets/images/avatar_alex.png';
  static const _imgTrueLernLogo = 'assets/images/truelern_logo.png';

  static const _svgSpeaking = 'assets/icons/ic_speaking.svg';
  static const _svgThinking = 'assets/icons/ic_thinking.svg';
  static const _svgArrowRight = 'assets/icons/ic_arrow_right.svg';
  static const _svgAddChild = 'assets/icons/ic_add_child.svg';
  static const _svgBackArrow = 'assets/icons/ic_back_arrow.svg';
  static const _svgGroupProfile = 'assets/icons/ic_group_profile.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('parent_my_child_screen'),
      body: Container(
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
              // Header - TopAppBar (Node 76:1046)
              _buildTopAppBar(context),

              // Scrollable content (Node 76:963)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),

                      // Title & Subtitle Container (Node 76:964)
                      Text(
                        'My Child',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 36 / 28,
                          color: const Color(0xFF1A1B23),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select a profile to view their learning journey.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 24 / 16,
                          color: const Color(0xFF434655),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Child Card 1: Mia (Node 76:970)
                      _buildChildCard(
                        context,
                        name: 'Mia',
                        age: 'Age 9',
                        skill: 'Communication & Public Speaking',
                        skillIcon: _svgSpeaking,
                        avatarAsset: _imgAvatarMia,
                        accentColor: const Color(0xFF22D3EE),
                        skillPillBgColor: const Color(0x1A22D3EE), // 10% opacity
                        progressValue: 0.72,
                        progressText: '72%',
                        attendanceValue: 0.94,
                        attendanceText: '94%',
                      ),

                      const SizedBox(height: 24),

                      // Child Card 2: Alex (Node 76:1005)
                      _buildChildCard(
                        context,
                        name: 'Alex',
                        age: 'Age 12',
                        skill: 'Practical Thinking',
                        skillIcon: _svgThinking,
                        avatarAsset: _imgAvatarAlex,
                        accentColor: const Color(0xFFA855F7),
                        skillPillBgColor: const Color(0x1AA855F7), // 10% opacity
                        progressValue: 0.45,
                        progressText: '45%',
                        attendanceValue: 0.88,
                        attendanceText: '88%',
                      ),

                      const SizedBox(height: 24),

                      // Button - Add Child Card (Node 76:1040)
                      _buildAddChildCard(context),

                      const SizedBox(height: 32),
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

  /// TopAppBar matching Figma Node 76:1046
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left back button (Node 101:50)
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              borderRadius: BorderRadius.circular(9999),
              onTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  context.go(AppRoutePaths.parentProfile);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  _svgBackArrow,
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0037B1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),

          // Center logo (Node 76:1807)
          Image.asset(
            _imgTrueLernLogo,
            width: 120,
            height: 41,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Text(
              'TrueLern',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0037B1),
              ),
            ),
          ),

          // Right button (Node 76:1050)
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  _svgGroupProfile,
                  width: 22,
                  height: 16,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF434655),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Child Card matching Figma Nodes 76:970 & 76:1005
  Widget _buildChildCard(
    BuildContext context, {
    required String name,
    required String age,
    required String skill,
    required String skillIcon,
    required String avatarAsset,
    required Color accentColor,
    required Color skillPillBgColor,
    required double progressValue,
    required String progressText,
    required double attendanceValue,
    required String attendanceText,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: accentColor,
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
      padding: const EdgeInsets.only(left: 24, right: 20, top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Avatar + Name/Age + Skill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar (Node 76:972 / 76:1007)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF3F2FE),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    avatarAsset,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: accentColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Name, Age Pill, Skill Overlay (Node 76:974 / 76:1009)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name & Age Row
                    Row(
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 28 / 20,
                            color: const Color(0xFF1A1B23),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDEDF9),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            age,
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 16 / 12,
                              color: const Color(0xFF434655),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Skill Overlay Pill (Node 76:979 / 76:1014)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: skillPillBgColor,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            skillIcon,
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              skill,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                height: 16 / 12,
                                color: const Color(0xFF1A1B23),
                              ),
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

          const SizedBox(height: 24),

          // Two Bento Metric Boxes (Node 76:984 / 76:1019)
          Row(
            children: [
              // Box 1: Overall Progress (Node 76:985 / 76:1020)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Progress',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          color: const Color(0xFF434655),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        progressText,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          color: const Color(0xFF0037B1),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Box 2: Attendance (Node 76:993 / 76:1028)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF8FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 16 / 12,
                          color: const Color(0xFF434655),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attendanceText,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 28 / 20,
                          color: const Color(0xFF1A1B23),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: LinearProgressIndicator(
                          value: attendanceValue,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0037B1)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Button - VIEW CHILD (Node 76:1001 / 76:1036)
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E4ED8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'VIEW CHILD',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 20 / 14,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    _svgArrowRight,
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Button - Add Child Card matching Figma Node 76:1040
  Widget _buildAddChildCard(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        color: const Color(0xFFC4C5D7),
        strokeWidth: 2,
        radius: 16,
        dashWidth: 6,
        dashSpace: 4,
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circle with + icon (Node 76:1041)
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8E7F3),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    _svgAddChild,
                    width: 19,
                    height: 19,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF434655),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ADD CHILD',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                  color: const Color(0xFF434655),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter to render exact dashed border around rounded rectangle
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashSpace;

  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        dashedPath.addPath(
          metric.extractPath(distance, distance + length),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius;
}
