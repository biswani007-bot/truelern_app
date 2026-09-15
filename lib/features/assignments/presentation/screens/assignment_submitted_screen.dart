import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/assignment_entity.dart';

/// SCR-19: Assignment Submitted Screen (Figma Node 76:2611 "Assignment Submitted (Revised)")
///
/// Features matching 100% Figma specification:
/// 1. Background gradient: LinearGradient 135.1 deg (#F3E8FF 0%, #E0F2FE 50%, #FFFFFF 100%).
/// 2. Success Hero Section (76:2613):
///    - Clay 3D Tile (192x192, 32px radius, rotated 3 deg, deep elevation shadow, 4px white border)
///      with purple puzzle piece icon (76:2619, `submission_puzzle_large.svg`).
///    - Success Badge (76:2621): 64x64 emerald circle (#10B981) with 4px solid white border,
///      elevation shadow, and centered white checkmark (`submission_badge_check.svg`).
///    - Title (76:2627): "Assignment Submitted" in 28px Hanken Grotesk Bold, color #0037B1.
///    - Subtitle (76:2629): "Great job! Your Practical Thinking assignment is\nsecurely in the hands of our reviewers."
///      in 16px Regular #434655.
/// 3. Details & Context Grid (Bento Style) (76:2631):
///    - Summary Card (76:2632):
///      - 4px Purple (#A855F7) accent left bar.
///      - Document icon (`submission_doc_icon.svg`) + "Submission Details" (16px SemiBold #1A1B23).
///      - Row 1: "Submitted" (14px Regular #434655) vs "Today, 4:30 PM" (14px SemiBold #1A1B23), separated by #E2E1ED border.
///      - Row 2: "Status" vs "Under Review" pill with hourglass icon (`submission_hourglass.svg`, #0037B1 text on #E8E7F3).
///    - Related Class Context Card (76:2651):
///      - Purple overlay box with small puzzle icon (`submission_puzzle_small.svg`).
///      - Topic: "PRACTICAL THINKING" (12px Medium #A855F7 uppercase, 0.6px letter spacing).
///      - Class title: "Problem Solving 101" (16px SemiBold #1A1B23).
///      - Description: "This assignment is connected to the recent live class. Review the materials if needed."
///      - "View Class Details ->" link button in #0037B1 with right arrow icon (`submission_arrow_right.svg`).
/// 4. Primary CTA (76:2668):
///    - Pill button in #0037B1 with elevation shadow: "BACK TO LEARNING" + graduation cap icon (`submission_cap.svg`).
class AssignmentSubmittedScreen extends StatelessWidget {
  final String? assignmentId;
  final AssignmentEntity? assignment;

  const AssignmentSubmittedScreen({
    super.key,
    this.assignmentId,
    this.assignment,
  });

  @override
  Widget build(BuildContext context) {
    final topic = assignment?.topic ?? 'Practical Thinking';
    final classTitle = 'Problem Solving 101';
    final submittedTime = 'Today, 4:30 PM';

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient matching TrueLern Figma canvas (Node 76:2611)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.8, -1.0),
                end: Alignment(0.8, 1.0),
                stops: [0.0, 0.5, 1.0],
                colors: [
                  Color(0xFFF3E8FF), // Light purple
                  Color(0xFFE0F2FE), // Sky blue tint
                  Color(0xFFFFFFFF), // Pure white
                ],
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 110),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. Success Hero Section (Figma Node 76:2613)
                      _buildHeroSection(topic),
                      const SizedBox(height: 36),

                      // 2. Details & Context Grid (Bento Style) (Figma Node 76:2631)
                      _buildSummaryCard(submittedTime),
                      const SizedBox(height: 16),
                      _buildRelatedClassCard(context, topic, classTitle),
                      const SizedBox(height: 36),

                      // 3. Primary CTA: BACK TO LEARNING (Figma Node 76:2668)
                      _buildBackToLearningButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 1. Success Hero Section (Node 76:2613)
  Widget _buildHeroSection(String topic) {
    return Column(
      children: [
        // Large Clay 3D Representation with Success Badge (Node 76:2614)
        SizedBox(
          width: 208,
          height: 208,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Blue blur shadow glow under clay card
              Positioned(
                left: 12,
                right: 12,
                top: 12,
                bottom: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E4ED8).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),

              // Rotated white 3D clay tile (Node 76:2617)
              Transform.rotate(
                angle: 3 * 3.141592653589793 / 180, // 3 deg
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 36,
                        offset: const Offset(0, 18),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/submission_puzzle_large.svg',
                      width: 64,
                      height: 67,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Green Success Badge with white checkmark (Node 76:2621)
              Positioned(
                right: 4,
                bottom: 2,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/submission_badge_check.svg',
                      width: 23,
                      height: 18,
                      fit: BoxFit.contain,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Heading 1: "Assignment Submitted" (Node 76:2627)
        Text(
          'Assignment Submitted',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0037B1),
            letterSpacing: -0.7,
            height: 36 / 28,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle (Node 76:2629)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Great job! Your $topic assignment is\nsecurely in the hands of our reviewers.',
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF434655),
              height: 24 / 16,
            ),
          ),
        ),
      ],
    );
  }

  /// 2A. Summary Card (Node 76:2632)
  Widget _buildSummaryCard(String submittedTime) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color(0xFFA855F7), // Purple accent bar (76:2650)
              width: 4,
            ),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading 3: "Submission Details" (Node 76:2633)
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/submission_doc_icon.svg',
                  width: 16,
                  height: 20,
                  colorFilter: const ColorFilter.mode(Color(0xFF1A1B23), BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Submission Details',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1B23),
                      height: 24 / 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 1: Submitted vs Today, 4:30 PM (Node 76:2638)
            Container(
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E1ED), width: 1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Submitted',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF434655),
                        height: 20 / 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    submittedTime,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1B23),
                      letterSpacing: 0.1,
                      height: 20 / 14,
                    ),
                  ),
                ],
              ),
            ),

            // Row 2: Status vs Under Review pill (Node 76:2643)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Status',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF434655),
                        height: 20 / 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E7F3),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/submission_hourglass.svg',
                          width: 11,
                          height: 14,
                          colorFilter: const ColorFilter.mode(Color(0xFF0037B1), BlendMode.srcIn),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Under Review',
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF0037B1),
                            height: 16 / 12,
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

  /// 2B. Related Class Context Card (Node 76:2651)
  Widget _buildRelatedClassCard(BuildContext context, String topic, String classTitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Class header: Icon + Topic uppercase + Title (Node 76:2653)
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFA855F7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/submission_puzzle_small.svg',
                    width: 19,
                    height: 20,
                    colorFilter: const ColorFilter.mode(Color(0xFFA855F7), BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.toUpperCase(),
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA855F7),
                        letterSpacing: 0.6,
                        height: 16 / 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      classTitle,
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1B23),
                        height: 20 / 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Description (Node 76:2663)
          Text(
            'This assignment is connected to the recent live class. Review the materials if needed.',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF434655),
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: 14),

          // "View Class Details ->" link (Node 76:2664)
          InkWell(
            key: const Key('view_class_details_link'),
            onTap: () {
              if (context.canPop()) {
                context.pop();
              }
              context.go('/parent/classes');
            },
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View Class Details',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF0037B1),
                      letterSpacing: 0.1,
                      height: 20 / 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/submission_arrow_right.svg',
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(Color(0xFF0037B1), BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Primary CTA: BACK TO LEARNING (Node 76:2668)
  Widget _buildBackToLearningButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        key: const Key('back_to_learning_button'),
        onPressed: () {
          context.go('/parent/classes/program');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0037B1),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BACK TO LEARNING',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.1,
                height: 20 / 14,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/submission_cap.svg',
              width: 22,
              height: 18,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
