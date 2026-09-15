import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// Topic Detail (New) Screen — Figma Frame `76:2930`
///
/// Figma Page: Parent(full app)_TreLern
/// Node: 76:2930 — "Topic Detail (New)" (390 x 1332.95)
///
/// Navigation entry: CurrentProgramScreen → tap "Speaking With Confidence" card → here.
/// Back: returns to CurrentProgramScreen.
/// Bottom navigation: Provided by ParentShellScreen (1 persistent navbar, "My Classes" active).
class TopicDetailScreen extends ConsumerWidget {
  const TopicDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // Figma bg: linear-gradient(106.31deg, #F3E8FF 0%, #E0F2FE 50%, #FFFFFF 100%)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0, -0.2926),
            end: Alignment(1.0, 0.2926),
            stops: [0.0, 0.5, 1.0],
            colors: [
              Color(0xFFF3E8FF),
              Color(0xFFE0F2FE),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              // ── Scrollable content Canvas (Node 76:2931) ─────────────────
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 76,
                  bottom: 96,
                ),
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeroSection(),
                      const SizedBox(height: 24),
                      _buildLiveClassCard(),
                      const SizedBox(height: 24),
                      _buildPracticeCard(),
                      const SizedBox(height: 24),
                      _buildAssignmentCard(),
                      const SizedBox(height: 24),
                      _buildProgressCard(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── TopAppBar (Node 76:3021) ─────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopAppBar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TOP APP BAR  (Node 76:3021)
  // backdrop-blur 6px · bg rgba(255,255,255,0.80) · shadow 0 1 2 rgba(0,0,0,0.05)
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildTopAppBar(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 8, 16, 8),
      decoration: const BoxDecoration(
        color: Color(0xCCFFFFFF), // rgba(255, 255, 255, 0.80)
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back Arrow (Node 76:3023) — 16×16px
          GestureDetector(
            key: const Key('topic_detail_back_button'),
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/parent/classes/program');
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                'assets/icons/topic_back_icon.svg',
                width: 16,
                height: 16,
              ),
            ),
          ),

          // TrueLern Wordmark Logo (Node 76:3026) — 132 x 45.26px
          SizedBox(
            width: 132,
            height: 45.26,
            child: Image.asset(
              'assets/images/figma_topic_logo.png',
              fit: BoxFit.contain,
            ),
          ),

          // 3-dot Kebab Menu (Node 76:3027) — 4 x 16px SVG
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              'assets/icons/topic_three_dots_icon.svg',
              width: 4,
              height: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // HERO SECTION  (Node 76:2932)
  // 150×144 3D Heart+Brain puzzle illustration · cyan badge · bold 28px title · 16px subtitle
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 3D Heart + Brain Illustration (Node 76:2933) — 150×144px
        SizedBox(
          width: 150,
          height: 144,
          child: Image.asset(
            'assets/images/figma_topic_hero.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 16),

        // "Communication" Pill Badge (Node 76:2936)
        // bg rgba(34,211,238,0.10) · radius 9999 · px 12 · py 4
        // text: HankenGrotesk Medium 12px #22D3EE
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x1A22D3EE), // rgba(34, 211, 238, 0.10)
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            'Communication',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF22D3EE),
              height: 16 / 12,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Title (Node 76:2939) — Bold 28px #1A1B23 centered
        Text(
          'Speaking With Confidence',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1B23),
            height: 36 / 28,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle (Node 76:2941) — Regular 16px #434655 centered
        Text(
          'Learn techniques to project your voice, overcome\n'
          'stage fright, and deliver your message with clarity\n'
          'and impact.',
          textAlign: TextAlign.center,
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

  // ════════════════════════════════════════════════════════════════════════
  // LIVE CLASS CARD  (Node 76:2943)
  // bg white · border-left 4px #0037B1 · radius 16 · shadow 0 4 20 rgba(0,0,0,0.04)
  // pl 24 · pr 20 · py 20 · gap 16
  // Faint watermark SVG at top-right (Node 76:2944)
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildLiveClassCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFF0037B1), width: 4),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Watermark (Node 76:2944) — 82 x 79px at top: 0, right: 0
            Positioned(
              top: 0,
              right: 0,
              width: 82,
              height: 79,
              child: SvgPicture.asset(
                'assets/icons/topic_live_class_bg.svg',
                fit: BoxFit.contain,
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Live Class" + "Tomorrow, 7:00 PM"
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SemiBold 16px #1A1B23
                          Text(
                            'Live Class',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1B23),
                              height: 24 / 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Bold 12px #0037B1
                          Text(
                            'Tomorrow, 7:00 PM',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0037B1),
                              height: 16 / 12,
                            ),
                          ),
                        ],
                      ),

                      // Video Call Icon (Node 76:2952) — 36×41px SVG
                      SvgPicture.asset(
                        'assets/icons/topic_video_icon.svg',
                        width: 36,
                        height: 41,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Description — Regular 14px #434655
                  Text(
                    'Join Instructor Sarah for an interactive session on\nvocal projection techniques.',
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

  // ════════════════════════════════════════════════════════════════════════
  // PRACTICE CARD  (Node 76:2958)
  // bg white · radius 16 · shadow 0 4 20 rgba(0,0,0,0.04) · p 20
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildPracticeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Practice" / "Self-paced modules" | sliders icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1B23),
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Self-paced modules',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF434655),
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),

              // Tuning/sliders icon (Node 76:2965) — 32×43px
              SvgPicture.asset(
                'assets/icons/topic_practice_icon.svg',
                width: 32,
                height: 43,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Chips row: Voice | Poise | Clarity
          // Each: bg #F3F2FE, radius 8, p 8
          Row(
            children: [
              _buildPracticeChip(
                iconAsset: 'assets/icons/topic_voice_icon.svg',
                iconWidth: 22,
                iconHeight: 22.95,
                label: 'Voice',
              ),
              const SizedBox(width: 12),
              _buildPracticeChip(
                iconAsset: 'assets/icons/topic_poise_icon.svg',
                iconWidth: 20,
                iconHeight: 24,
                label: 'Poise',
              ),
              const SizedBox(width: 12),
              _buildPracticeChip(
                iconAsset: 'assets/icons/topic_clarity_icon.svg',
                iconWidth: 20,
                iconHeight: 24,
                label: 'Clarity',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // "Start Practice" outlined button (Node 76:2985)
          // border 1px #C4C5D7 · radius 8 · py 11
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC4C5D7)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Center(
                    child: Text(
                      'Start Practice',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1A1B23),
                        letterSpacing: 0.1,
                        height: 20 / 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Single practice chip tile (Voice / Poise / Clarity)
  /// bg #F3F2FE · radius 8 · p 8 · exact SVG icon + label 10px #434655
  Widget _buildPracticeChip({
    required String iconAsset,
    required double iconWidth,
    required double iconHeight,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F2FE),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 23,
              child: SvgPicture.asset(
                iconAsset,
                width: iconWidth,
                height: iconHeight,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF434655),
                height: 15 / 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // ASSIGNMENT CARD  (Node 76:2987)
  // bg white · border-left 4px #9333EA · radius 16 · drop-shadow 0 4 10 rgba(0,0,0,0.04)
  // pl 24 · pr 20 · py 20 · gap 16
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildAssignmentCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFF9333EA), width: 4),
        ),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "Assignment" — SemiBold 16px #1A1B23
                      Text(
                        'Assignment',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1B23),
                          height: 24 / 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // "Due in 3 days" — Bold 12px #9333EA
                      Text(
                        'Due in 3 days',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF9333EA),
                          height: 16 / 12,
                        ),
                      ),
                    ],
                  ),

                  // Clipboard icon (Node 76:2994) — 34×43px SVG
                  SvgPicture.asset(
                    'assets/icons/topic_assignment_icon.svg',
                    width: 34,
                    height: 43,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description — Regular 14px #434655
              Text(
                'Record a 2-minute reflection on a recent\nconversation where you felt confident.',
                style: GoogleFonts.hankenGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF434655),
                  height: 20 / 14,
                ),
              ),

              const SizedBox(height: 16),

              // "Submit Reflection" button (Node 76:2998)
              // border 1px #C4C5D7 · radius 8 · py 11 · file icon + label
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFC4C5D7)),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/topic_submit_doc_icon.svg',
                            width: 9.33,
                            height: 11.67,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Submit Reflection',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1A1B23),
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
          ),
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════
  // TOPIC PROGRESS CARD  (Node 76:3002)
  // bg white · radius 16 · drop-shadow 0 4 10 rgba(0,0,0,0.04) · p 20
  // ════════════════════════════════════════════════════════════════════════
  Widget _buildProgressCard() {
    const double progress = 0.64; // 64% per Figma

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Topic Progress" / "Keep it up!" | trend icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Topic Progress" — SemiBold 16px #1A1B23
                  Text(
                    'Topic Progress',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1B23),
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // "Keep it up!" — Medium 12px #434655
                  Text(
                    'Keep it up!',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF434655),
                      height: 16 / 12,
                    ),
                  ),
                ],
              ),

              // Trend arrow icon (Node 76:3010) — 36×35px cyan
              SvgPicture.asset(
                'assets/icons/topic_progress_trend_icon.svg',
                width: 36,
                height: 35,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // "64% | Completed" row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 64% — 48px bold + 24px percent
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '64',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1B23),
                        letterSpacing: -0.96,
                        height: 56 / 48,
                      ),
                    ),
                    TextSpan(
                      text: '%',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF434655),
                        height: 32 / 24,
                      ),
                    ),
                  ],
                ),
              ),

              // "Completed" — Medium 12px #434655, pb 4
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Completed',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF434655),
                    height: 16 / 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Progress bar — bg #F1F5F9 · fill #22D3EE (64%) · h 6 · radius 9999
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE),
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}