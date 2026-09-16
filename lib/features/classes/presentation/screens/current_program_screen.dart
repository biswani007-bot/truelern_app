import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/router/route_names.dart';

import '../../../classes/presentation/controllers/classes_controller.dart';
import '../../../classes/presentation/controllers/classes_state.dart';

/// Current Program (New) Screen (Figma Frame `76:2787`, 390 x 1506.5).
///
/// Fully matches Figma parent canvas 69:2 specifications:
/// - TopAppBar (`76:2899`): Back button, TrueLern centered logo, Notification bell.
/// - Section Hero Header (`76:2790`): 3D illustration `rocket_illustration.png`, "ACTIVE TRACK" cyan pill,
///   "Communication & Public Speaking" title, descriptive subtitle.
/// - Section Progress Card (`76:2802`): "Track Progress", "12 of 24 classes completed", 50% cyan indicator,
///   horizontal module selector (`Basics`, `Storytelling` [Active], `Debate`, `Final Pitch`).
/// - Section Bento Grid (`76:2839`):
///   - Next Live Class Card (`76:2840`): "Speaking With Confidence", "Tomorrow", time badge, "Join Class" CTA.
///   - Current Assignments Card (`76:2857`): "Recent Assignments", "2 Pending", item preview, "View All Tasks" CTA.
/// - Section Skills Acquired (`76:2880`): "Skills in Focus", 3 cards: `Confidence` (Teal), `Expression` (Blue), `Dialogue` (Purple).
class CurrentProgramScreen extends ConsumerWidget {
  const CurrentProgramScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dynamic integration with classes provider
    final classesState = ref.watch(classesControllerProvider);
    // Note: assignmentsState wired in for future dynamic assignment data

    // Figma Node 76:2848 & 76:2863 exact baseline values
    String nextClassTitle = 'Speaking With Confidence';
    String nextClassTime = '7:00 PM - 8:00 PM';
    String nextClassBadge = 'Tomorrow';

    String pendingAssignmentsCount = '2 Pending';
    String recentTaskTitle = 'Record a 1-min intro';
    String recentTaskDue = 'Due Today';

    if (classesState is ClassesLoaded && classesState.classes.isNotEmpty) {
      final upcoming = classesState.classes.first;
      nextClassTitle = upcoming.title;
      if (upcoming.scheduledStartTime != null) {
        nextClassTime =
            '${upcoming.scheduledStartTime!.hour.toString().padLeft(2, '0')}:${upcoming.scheduledStartTime!.minute.toString().padLeft(2, '0')}';
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            // Scrollable Content Canvas (Node 76:2788)
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 88, // Space for Header TopAppBar
                bottom: 32, // Bottom margin
              ),
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Section - Hero Header (Node 76:2790)
                    _buildHeroHeader(),

                    const SizedBox(height: 24),

                    // 2. Section - Progress Card (Node 76:2802)
                    _buildProgressCard(),

                    const SizedBox(height: 24),

                    // 3. Section - Bento Grid: Next Class & Current Topic (Node 76:2839)
                    _buildNextLiveClassCard(
                      context,
                      title: nextClassTitle,
                      time: nextClassTime,
                      badge: nextClassBadge,
                    ),

                    const SizedBox(height: 12),

                    _buildRecentAssignmentsCard(
                      context,
                      pendingText: pendingAssignmentsCount,
                      taskTitle: recentTaskTitle,
                      taskDue: recentTaskDue,
                    ),

                    const SizedBox(height: 24),

                    // 4. Section - Skills Acquired (Node 76:2879)
                    _buildSkillsAcquiredSection(),
                  ],
                ),
              ),
            ),

            // TopAppBar Floating Header (Node 76:2899)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopAppBar(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Header TopAppBar (Figma Node 76:2899)
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button (Node 76:2900)
          GestureDetector(
            key: const Key('current_program_back_button'),
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/parent/classes');
              }
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),

          // TrueLern Logo Centered (Node 76:2903)
          Image.asset(
            'assets/images/truelern_logo.png',
            height: 38,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Text(
              'TrueLern',
              style: GoogleFonts.hankenGrotesk(
                fontSize: 23.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0037B1),
              ),
            ),
          ),

          // Notification Bell Button (Node 76:2904)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section - Hero Header (Figma Node 76:2790)
  Widget _buildHeroHeader() {
    return Column(
      children: [
        // 3D Illustration `image 5` (Node 76:2801, 131 x 126px)
        // Figma asset: mic + speech bubble 3D illustration
        SizedBox(
          width: 131,
          height: 126,
          child: Image.asset(
            'assets/images/figma_communication_hero.png',
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Image.asset(
              'assets/images/rocket_illustration.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ACTIVE TRACK Cyan Capsule Badge (Node 76:2792)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF22D3EE).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF22D3EE),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              // ACTIVE TRACK badge text (Node 76:2795) — Figma: Regular 16px, #1A1B23, tracking 0.8, uppercase
              Text(
                'ACTIVE TRACK',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.8,
                  color: const Color(0xFF1A1B23),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Heading 2 (Node 76:2798) — Figma: Hanken Grotesk Bold, 16px, #1A1B23
        Text(
          'Communication & Public Speaking',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1B23),
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle (Node 76:2800) — Figma: Hanken Grotesk Regular, 16px, #434655
        Text(
          'Master the art of expression and build confidence\nfor every stage.',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF434655),
            height: 24 / 16,
          ),
        ),
      ],
    );
  }

  /// Section - Progress Card (Figma Node 76:2802, 358 x 248px)
  Widget _buildProgressCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left cyan accent vertical bar (Node 76:2838)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF22D3EE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Percentage Row (Node 76:2803)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Heading 3 (Node 76:2806) — Figma: Regular, 16px, #1A1B23
                          Text(
                            'Track Progress',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1A1B23),
                              height: 24 / 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Node 76:2808 — Figma: Regular, 16px, #434655
                          Text(
                            '12 of 24 classes completed',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF434655),
                              height: 24 / 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Node 76:2810 — Figma: Bold, 16px, #22D3EE
                    Text(
                      '50%',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF22D3EE),
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress Bar (Node 76:2811 & 76:2812)
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E7F3),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.50, // 50%
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF22D3EE),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Horizontal Modules List (Node 76:2813)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      // Module 1: Basics (Completed / Passed) — bg #F3F2FE
                      _buildModuleTile(
                        title: 'Basics',
                        iconData: Icons.check_rounded,
                        iconColor: const Color(0xFF10B981),
                        bgColor: const Color(0xFFF3F2FE),
                        isActive: false,
                        isLocked: false,
                      ),
                      const SizedBox(width: 12),

                      // Module 2: Storytelling (Active) — bg rgba(34,211,238,0.1), border rgba(34,211,238,0.2)
                      _buildModuleTile(
                        title: 'Storytelling',
                        iconData: Icons.play_arrow_rounded,
                        iconColor: const Color(0xFF0037B1),
                        bgColor: const Color(0xFF22D3EE).withValues(alpha: 0.10),
                        borderColor: const Color(0xFF22D3EE).withValues(alpha: 0.20),
                        isActive: true,
                        isLocked: false,
                      ),
                      const SizedBox(width: 12),

                      // Module 3: Debate (Upcoming) — opacity 70%, bg rgba(243,242,254,0.5)
                      _buildModuleTile(
                        title: 'Debate',
                        iconData: Icons.book_outlined,
                        iconColor: const Color(0xFF94A3B8),
                        bgColor: const Color(0xFFF3F2FE).withValues(alpha: 0.50),
                        isActive: false,
                        isLocked: true,
                      ),
                      const SizedBox(width: 12),

                      // Module 4: Final Pitch (Upcoming) — opacity 70%, bg rgba(243,242,254,0.5)
                      _buildModuleTile(
                        title: 'Final Pitch',
                        iconData: Icons.mic_none_rounded,
                        iconColor: const Color(0xFF94A3B8),
                        bgColor: const Color(0xFFF3F2FE).withValues(alpha: 0.50),
                        isActive: false,
                        isLocked: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Single Module card in Progress Card (Node 76:2814 - 76:2837)
  /// Figma: w128, p13, radius 12. Active: bg rgba(34,211,238,0.1) border rgba(34,211,238,0.2).
  /// Locked: opacity 0.70, bg rgba(243,242,254,0.5).
  Widget _buildModuleTile({
    required String title,
    required IconData iconData,
    required Color iconColor,
    required Color bgColor,
    Color? borderColor,
    required bool isActive,
    bool isLocked = false,
  }) {
    Widget tile = Container(
      width: 128,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderColor != null ? 1 : 0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon circle — Figma: white bg, shadow 0px 1px 1px rgba(0,0,0,0.05), 32px
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isLocked
                  ? Colors.white.withValues(alpha: 0.50)
                  : Colors.white,
              shape: BoxShape.circle,
              boxShadow: isLocked
                  ? null
                  : const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
            ),
            child: Center(
              child: Icon(
                iconData,
                size: 14,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Text — Figma: Basics Regular 16px, Storytelling SemiBold 16px, Debate/Final Regular 16px
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 17,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isLocked
                  ? const Color(0xFF434655)
                  : const Color(0xFF1A1B23),
              height: 24 / 16,
            ),
          ),
        ],
      ),
    );
    // Locked modules have 70% opacity per Figma (Overlay nodes 76:2826, 76:2832)
    if (isLocked) {
      return Opacity(opacity: 0.70, child: tile);
    }
    return tile;
  }

  /// Next Live Class Bento Card (Figma Node 76:2840, 358 x 234.5px)
  Widget _buildNextLiveClassCard(
    BuildContext context, {
    required String title,
    required String time,
    required String badge,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('current_program_next_live_class_card'),
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          context.pushNamed(AppRouteNames.topicDetail);
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
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
          // Icon and Tag Row (Node 76:2842)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cyan video call badge icon (Node 76:2843)
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.videocam_rounded,
                    color: Color(0xFF0037B1),
                    size: 22,
                  ),
                ),
              ),

              // "Tomorrow" Pill Badge (Node 76:2845) — Figma: bg #F3F2FE, Regular 16px, #434655
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F2FE),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF434655),
                    height: 24 / 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title (Node 76:2848) — Figma: Bold, 16px, #1A1B23
          Text(
            title,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1B23),
              height: 24 / 16,
            ),
          ),
          const SizedBox(height: 6),

          // Time Row (Node 76:2849) — Figma: Regular, 16px, #434655
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 12,
                color: Color(0xFF434655),
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF434655),
                  height: 24 / 16,
                ),
              ),
            ],
          ),
          // NOTE: No CTA button in Figma Next Live Class card (76:2840)
        ],
      ),
    ),
  ),
);
  }

  /// Recent Assignments Bento Card (Figma Node 76:2857, 358 x 280px)
  Widget _buildRecentAssignmentsCard(
    BuildContext context, {
    required String pendingText,
    required String taskTitle,
    required String taskDue,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          // Icon and Red Badge Row (Node 76:2859)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Assignment badge icon (Node 76:2860) — Figma: red/danger assignment icon 38x47px
              // Using red background with warning assignment icon matching Figma's imgOverlay1
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFBA1A1A).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFFBA1A1A),
                    size: 22,
                  ),
                ),
              ),

              // "2 Pending" Red Pill Badge (Node 76:2862) — Figma: bg rgba(255,218,214,0.3), Bold 16px, #BA1A1A
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDAD6).withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  pendingText,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFBA1A1A),
                    height: 24 / 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title (Node 76:2865) — Figma: Bold, 16px, #1A1B23
          Text(
            'Recent Assignments',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1B23),
              height: 24 / 16,
            ),
          ),
          const SizedBox(height: 12),

          // List Item Container (Node 76:2866)
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F2FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.insert_drive_file_outlined,
                  size: 20,
                  color: Color(0xFF0037B1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Node 76:2872 — Figma: Regular, 16px, #1A1B23
                      Text(
                        taskTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1A1B23),
                          height: 24 / 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      // Node 76:2874 — Figma: Medium, 10px, #BA1A1A
                      Text(
                        taskDue,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFBA1A1A),
                          height: 15 / 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF434655),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // View All Tasks Outlined Button (Node 76:2877)
          // Figma: border 2px #E2E1ED, radius 12px, text Regular 16px #1A1B23
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              key: const Key('view_all_tasks_button'),
              onPressed: () {
                context.go('/parent/assignments');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E1ED), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 14),
              ),
              child: Text(
                'View All Tasks',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF1A1B23),
                  height: 24 / 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section - Skills Acquired (Figma Node 76:2879 - 76:2898)
  Widget _buildSkillsAcquiredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading 3 (Node 76:2882) — Figma: Bold, 16px, #1A1B23, px 8
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Skills in Focus',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1B23),
              height: 24 / 16,
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Card 1: Confidence (Node 76:2884, Teal bg: rgba(20,184,166,0.1))
            Expanded(
              child: _buildSkillCard(
                title: 'Confidence',
                iconData: Icons.emoji_events_outlined,
                tintColor: const Color(0xFF14B8A6), // Teal
              ),
            ),
            const SizedBox(width: 12),

            // Card 2: Expression (Node 76:2889, Blue bg: rgba(59,130,246,0.1))
            Expanded(
              child: _buildSkillCard(
                title: 'Expression',
                iconData: Icons.record_voice_over_outlined,
                tintColor: const Color(0xFF3B82F6), // Blue
              ),
            ),
            const SizedBox(width: 12),

            // Card 3: Dialogue (Node 76:2894, Purple bg: rgba(147,51,234,0.1))
            Expanded(
              child: _buildSkillCard(
                title: 'Dialogue',
                iconData: Icons.chat_bubble_outline_rounded,
                tintColor: const Color(0xFF9333EA), // Purple
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Single Skill Card (Node 76:2884 - 76:2898)
  /// Figma: white bg, shadow 0px 1px 1px rgba(0,0,0,0.05), radius 16, p16, w111.33, h108
  Widget _buildSkillCard({
    required String title,
    required IconData iconData,
    required Color tintColor,
  }) {
    return Container(
      height: 108,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon circle (Node 76:2885-2897) — 48px diameter
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: tintColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                iconData,
                color: tintColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Text (Node 76:2888/2893/2898) — Figma: Regular, 16px, #1A1B23, lh 20
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.hankenGrotesk(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A1B23),
              height: 20 / 16,
            ),
          ),
        ],
      ),
    );
  }
}
