import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/router/route_paths.dart';

/// Teacher Feedback (Revised) Screen — PURE STATIC FRONTEND ONLY.
///
/// Figma Source of Truth:
/// - File: `Parent(full app)_TreLern`
/// - Screen: `Teacher Feedback (Revised)` (Node `76:2697`, 390 × 1133px)
///
/// STRICT RULES:
/// - NO backend calls / NO API calls / NO database / NO network requests.
/// - Static frontend only, works 100% offline.
/// - Exact visual reproduction of Figma frame 76:2697.
class TeacherFeedbackScreen extends StatelessWidget {
  const TeacherFeedbackScreen({super.key});

  static const _imgLogo = 'assets/images/figma_truelern_logo.png';
  static const _imgMsSarah = 'assets/images/figma_ms_sarah.png';
  static const _imgPracticalThinking = 'assets/images/figma_practical_thinking.png';
  static const _imgProblemSolving = 'assets/images/figma_problem_solving.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('teacher_feedback_screen'),
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
              // ── Header - TopAppBar (Node 76:2721) ─────────────────
              _buildTopAppBar(context),

              // ── Main Scrollable Content Canvas (Node 76:2730) ─────
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('teacher_feedback_scroll_view'),
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 448),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Section: Assignment Header (Node 76:2731) ─────
                          _buildAssignmentHeader(),
                          const SizedBox(height: 24),

                          // ── Section: Feedback Card (Node 76:2741) ─────────
                          _buildFeedbackCard(),
                          const SizedBox(height: 24),

                          // ── Section: Skill Impact (Node 76:2759) ──────────
                          _buildSkillImpactSection(),
                          const SizedBox(height: 24),

                          // ── Section: Call to Action (Node 76:2783) ────────
                          _buildContinueLearningButton(context),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Bottom Nav Bar (Mobile) (Node 76:2698) ─────────────
              _buildBottomNav(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Header - TopAppBar (Node 76:2721)
  Widget _buildTopAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.80),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Button - Back (Node 76:2722)
              InkWell(
                key: const Key('teacher_feedback_back_button'),
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
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1A1B23),
                    size: 20,
                  ),
                ),
              ),

              // Heading 1: TrueLern Logo (Node 76:2725 / 76:2726)
              SizedBox(
                height: 36,
                child: Image.asset(
                  _imgLogo,
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
              ),

              // Button - Notifications (Node 76:2727)
              InkWell(
                key: const Key('teacher_feedback_notifications_button'),
                onTap: () {
                  context.push(AppRoutePaths.notifications);
                },
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF1A1B23),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section - Assignment Header (Node 76:2731)
  Widget _buildAssignmentHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category + Reviewed Badge Row (Node 76:2732)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DESIGN THINKING PROJECT',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF747686),
                letterSpacing: 0.6,
                height: 16 / 12,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0037B1).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                'REVIEWED',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0037B1),
                  height: 16 / 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Heading 2: Assignment Title (Node 76:2737 / 76:2738)
        Text(
          'Build a Sustainable City Model',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1B23),
            height: 36 / 28,
          ),
        ),
        const SizedBox(height: 8),

        // Submission Date (Node 76:2739 / 76:2740)
        Text(
          'Submitted on Oct 24, 2023',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF434655),
            height: 24 / 16,
          ),
        ),
      ],
    );
  }

  /// Section - Feedback Card (Glassmorphism) (Node 76:2741)
  Widget _buildFeedbackCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.50),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0, 0, 0, 0.05)
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Top-right blue decorative overlay (Node 76:2742)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFF0037B1).withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(9999),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Teacher Avatar + Info + Score (Node 76:2743)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teacher Avatar (Node 76:2744)
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        _imgMsSarah,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.person_rounded,
                          size: 32,
                          color: Color(0xFF0037B1),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Teacher Title & Role (Node 76:2745)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feedback from Ms. Sarah',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1B23),
                              height: 24 / 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Lead Instructor, Practical Thinking',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF747686),
                              height: 20 / 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Score block: 95/100 + Excellent Score! (Node 76:2750)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '95',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0037B1),
                                height: 36 / 28,
                              ),
                            ),
                            Text(
                              '/100',
                              style: GoogleFonts.hankenGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF747686),
                                height: 28 / 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Excellent\nScore!',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF434655),
                            height: 16 / 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Quote Box (Node 76:2756)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFE2E1ED),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '"Exceptional work on the sustainable city model! Your integration of renewable energy sources was highly innovative. You clearly demonstrated a strong grasp of practical problem-solving. Next time, try to expand more on the economic impact of the solar grids."',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF1A1B23),
                      height: 26 / 16,
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

  /// Section - Skill Impact (Node 76:2759)
  Widget _buildSkillImpactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Impact',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1B23),
            height: 28 / 20,
          ),
        ),
        const SizedBox(height: 12),

        // Skill Card 1: Practical Thinking (Node 76:2763)
        _buildSkillCard(
          title: 'Practical Thinking',
          percentString: '+12%',
          progressValue: 0.85,
          color: const Color(0xFFA855F7), // purple
          bgColor: const Color(0xFFA855F7).withValues(alpha: 0.10),
          imageAsset: _imgPracticalThinking,
        ),
        const SizedBox(height: 16),

        // Skill Card 2: Problem Solving (Node 76:2773)
        _buildSkillCard(
          title: 'Problem Solving',
          percentString: '+8%',
          progressValue: 0.70,
          color: const Color(0xFF3B82F6), // blue
          bgColor: const Color(0xFF3B82F6).withValues(alpha: 0.10),
          imageAsset: _imgProblemSolving,
        ),
      ],
    );
  }

  Widget _buildSkillCard({
    required String title,
    required String percentString,
    required double progressValue,
    required Color color,
    required Color bgColor,
    required String imageAsset,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Icon Container (48×48px)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.extension_rounded,
                  color: color,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Title + Progress Bar
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
                ),
                const SizedBox(height: 8),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Track
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E1ED),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        // Indicator
                        Container(
                          height: 6,
                          width: constraints.maxWidth * progressValue,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Pill (+12% or +8%)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              percentString,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
                height: 24 / 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section - Call to Action: CONTINUE LEARNING (Node 76:2783 / 76:2784)
  Widget _buildContinueLearningButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        key: const Key('teacher_feedback_continue_button'),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutePaths.parentAssignments);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0037B1),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: const Color(0x1A000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: Text(
          'CONTINUE LEARNING',
          style: GoogleFonts.hankenGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.5,
            height: 24 / 16,
          ),
        ),
      ),
    );
  }

  /// Bottom Nav Bar (Mobile) (Node 76:2698)
  Widget _buildBottomNav(BuildContext context) {
    final navItems = [
      _NavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        isActive: false,
        onTap: () => context.go(AppRoutePaths.parentDashboard),
      ),
      _NavItem(
        label: 'My Classes',
        icon: Icons.school_outlined,
        activeIcon: Icons.school_rounded,
        isActive: false,
        onTap: () => context.go(AppRoutePaths.parentClasses),
      ),
      _NavItem(
        label: 'Assignment',
        icon: Icons.assignment_outlined,
        activeIcon: Icons.assignment_rounded,
        isActive: true, // Node 76:2710 & 76:2715 shows Assignment active
        onTap: () => context.go(AppRoutePaths.parentAssignments),
      ),
      _NavItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        isActive: false,
        onTap: () => context.go(AppRoutePaths.parentProfile),
      ),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xCCFAF8FF), // rgba(250, 248, 255, 0.8) Figma Node 76:2698
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000), // rgba(0, 0, 0, 0.1)
            blurRadius: 15,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: navItems.map((item) {
              final color = item.isActive ? const Color(0xFF0037B1) : const Color(0xFF747686);

              return Expanded(
                child: InkWell(
                  onTap: item.onTap,
                  splashColor: const Color(0xFF0037B1).withValues(alpha: 0.08),
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.isActive ? item.activeIcon : item.icon,
                        size: 22,
                        color: color,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: GoogleFonts.hankenGrotesk(
                          color: color,
                          fontSize: 12,
                          fontWeight: item.isActive ? FontWeight.w600 : FontWeight.w500,
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;
}
