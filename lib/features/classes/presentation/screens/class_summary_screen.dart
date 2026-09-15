import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/class_entity.dart';

/// SCR-17 Class Summary Screen (Figma Node 76:2253 "Class Summary (Revised)")
///
/// Post-class session review screen for parents displaying:
/// - 3D Rocket & Gear celebration illustration
/// - "Class Completed" title
/// - Status chips: Attended, duration (42 / 45 minutes), teacher info
/// - "WHAT WE PRACTICED": Skills practiced during class (Voice, Communication, Confidence)
/// - "NEXT STEPS": Next Live Class reminder & Assignment card with due date
/// - Primary CTA: "VIEW ASSIGNMENT →"
class ClassSummaryScreen extends ConsumerWidget {
  final String classId;
  final ClassEntity? session;

  const ClassSummaryScreen({
    super.key,
    required this.classId,
    this.session,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient matching Figma:
          // linear-gradient(109.34deg, #F3E8FF 0%, #E0F2FE 50%, #FFFFFF 100%)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.8, -0.6),
                end: Alignment(0.8, 0.6),
                colors: [
                  Color(0xFFF3E8FF), // rgb(243, 232, 255)
                  Color(0xFFE0F2FE), // rgb(224, 242, 254)
                  Color(0xFFFFFFFF), // rgb(255, 255, 255)
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Main Scrollable Canvas
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 68, // Space for fixed TopAppBar
                bottom: 40, // Space below CTA button
                left: 16,
                right: 16,
              ),
              child: Center(

                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      // Hero Section: 3D Illustration & Success Indicator
                      _buildHeroSection(),
                      const SizedBox(height: 32),

                      // What We Practiced Section
                      _buildWhatWePracticedSection(),
                      const SizedBox(height: 32),

                      // Next Steps Section
                      _buildNextStepsSection(context),
                      const SizedBox(height: 32),

                      // Primary CTA Button: VIEW ASSIGNMENT
                      _buildViewAssignmentButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Fixed TopAppBar (Figma Node 76:2342)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopAppBar(context),
          ),
        ],
      ),
    );
  }

  /// TopAppBar with Frosted Glass (Figma Node 76:2342)
  Widget _buildTopAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 12,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.8),
            border: const Border(
              bottom: BorderSide(
                color: Color(0x0D000000), // rgba(0,0,0,0.05)
                width: 1,
              ),
            ),
          ),
          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hamburger Menu Button (Node 76:2343)
              InkWell(
                key: const Key('summary_menu_button'),
                borderRadius: BorderRadius.circular(9999),
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/parent/classes');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.menu_rounded,
                    color: const Color(0xFF1A1B23),
                    size: 24,
                  ),
                ),
              ),

              // TrueLern Logo (Node 76:2346)
              SizedBox(
                height: 32,
                child: Image.asset(
                  'assets/images/truelern_logo_header.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Text(
                    'TrueLern',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0037B1),
                    ),
                  ),
                ),
              ),

              // Notification Bell (Node 76:2347)
              InkWell(
                key: const Key('summary_notifications_button'),
                borderRadius: BorderRadius.circular(9999),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: const Color(0xFF1A1B23),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hero Section: 3D Rocket Illustration + Success Indicator + Status Chips
  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 3D Rocket with Gear Illustration (Node 76:2278)
        SizedBox(
          width: 200,
          height: 176,
          child: Image.asset(
            'assets/images/rocket_illustration.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 16),


        // Heading 2: Class Completed (Node 76:2259)
        Text(
          'Class Completed',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1B23),
            letterSpacing: -0.7,
            height: 36 / 28,
          ),
        ),
        const SizedBox(height: 16),

        // Key Details Chips (Node 76:2261)
        // Row 1: [Attended] [42 / 45 minutes]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chip 1: Attended (Node 76:2262)
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/check_circle.svg',
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF4F46E5),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Attended',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF4F46E5),
                          letterSpacing: 0.1,
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Chip 2: 42 / 45 minutes (Node 76:2267)
            ClipRRect(
              borderRadius: BorderRadius.circular(9999),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/time_clock.svg',
                        width: 14,
                        height: 14,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF434655),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '42 / 45 minutes',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF434655),
                          letterSpacing: 0.1,
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Row 2: Teacher: Sarah (Node 76:2273)
        SizedBox(
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/teacher_user.svg',
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF434655),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Teacher: Sarah',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF434655),
                        letterSpacing: 0.1,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }

  /// What We Practiced Section (Node 76:2280)
  Widget _buildWhatWePracticedSection() {
    final topics = [
      (
        title: 'Voice',
        svgPath: 'assets/icons/voice_mic.svg',
        color: const Color(0xFF22D3EE),
        bgColor: const Color.fromRGBO(34, 211, 238, 0.1),
      ),
      (
        title: 'Communication',
        svgPath: 'assets/icons/comm_bubble.svg',
        color: const Color(0xFF14B8A6),
        bgColor: const Color.fromRGBO(20, 184, 166, 0.1),
      ),
      (
        title: 'Confidence',
        svgPath: 'assets/icons/confidence_trophy.svg',
        color: const Color(0xFFA855F7),
        bgColor: const Color.fromRGBO(168, 85, 247, 0.1),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title: WHAT WE PRACTICED (Node 76:2282)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'WHAT WE PRACTICED',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF434655),
              height: 24 / 16,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal Skill Cards Row (Node 76:2283)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: topics.map((topic) {
              return Container(
                width: 124,
                height: 118,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF8FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000), // rgba(0,0,0,0.04)
                      blurRadius: 20,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon Circle (48x48)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: topic.bgColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        topic.svgPath,
                        width: 22,
                        height: 22,
                        colorFilter: ColorFilter.mode(
                          topic.color,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Label (Node 76:2289)
                    Text(
                      topic.title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1B23),
                        letterSpacing: 0.1,
                        height: 18 / 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Next Steps Section (Node 76:2306)
  Widget _buildNextStepsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title: NEXT STEPS (Node 76:2308)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'NEXT STEPS',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF434655),
              height: 24 / 16,
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Card 1: Next Live Class (Node 76:2310)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF8FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000), // rgba(0,0,0,0.04)
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Calendar Icon Badge (48x48)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E1ED),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/calendar_next_class.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF434655),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Live Class',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1B23),
                        height: 24 / 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Tomorrow, 7 PM',
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

              // Chevron Right (Node 76:2319)
              SvgPicture.asset(
                'assets/icons/chevron_right.svg',
                width: 8,
                height: 12,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF434655),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Card 2: Assignment with Left Blue Accent Bar (Node 76:2321)
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF8FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000), // rgba(0,0,0,0.04)
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Blue Accent Container with Clipboard Assignment Icon (48x48)
                  Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      color: const Color(0x1A0037B1), // rgba(0, 55, 177, 0.1)
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/assignment_clipboard.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF0037B1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),


                  // Texts
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assignment',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1A1B23),
                            height: 24 / 16,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/alert_clock.svg',
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFFBA1A1A),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Due Friday',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFBA1A1A),
                                height: 20 / 14,
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

            // Left Blue Accent Stripe (Node 76:2334)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF0037B1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Primary CTA Button: VIEW ASSIGNMENT (Node 76:2337)
  Widget _buildViewAssignmentButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF0037B1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330037B1), // rgba(0, 55, 177, 0.2)
            blurRadius: 15,
            offset: Offset(0, 10),
            spreadRadius: -3,
          ),
          BoxShadow(
            color: Color(0x330037B1),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const Key('view_assignment_button'),
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            context.go('/parent/assignments');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VIEW ASSIGNMENT',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 28 / 18,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/icons/arrow_right_btn.svg',
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
