import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/class_entity.dart';

/// SCR Live Classroom Screen (Figma Node 76:2191 "Live Classroom (New)")
///
/// Visual representation of the live virtual classroom session:
/// - Main stage showing teacher video feed ("Sarah Jenkins", "Instructor", pin & fullscreen controls)
/// - Bottom student carousel ("You", "Alex R." with muted mic, "Mia S.", "+9 Others")
/// - Top App Bar ("Public Speaking: Module 3", "Communication Track", "● LIVE" badge)
/// - Bottom Control Bar (Mic Toggle, Camera Toggle, "Leave" primary action)
///
/// Flow:
/// Joining Class (Revised) -> Live Classroom (New) -> Class Summary (Revised)
class LiveClassroomScreen extends StatefulWidget {
  final String classId;
  final ClassEntity? session;

  const LiveClassroomScreen({
    super.key,
    required this.classId,
    this.session,
  });

  @override
  State<LiveClassroomScreen> createState() => _LiveClassroomScreenState();
}

class _LiveClassroomScreenState extends State<LiveClassroomScreen> {
  bool _isMicOn = true;
  bool _isCameraOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient matching Figma:
          // linear-gradient(113.81deg, #F3E8FF 0%, #E0F2FE 50%, #FFFFFF 100%)
          Positioned.fill(
            child: Container(
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
          ),

          // Main Content Area (Figma Node 76:2192: inset [78px 0 82px 0], padding 16px)
          Positioned.fill(
            child: SafeArea(
              top: false,
              bottom: false,
              child: Column(
                children: [
                  // Spacer for Top Bar
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 110,
                  ),

                  // Middle Stage + Student Carousel (Figma Node 76:2192)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Main Stage (Teacher Video) - Figma Node 76:2193
                          Expanded(
                            child: _buildTeacherMainStage(),
                          ),
                          const SizedBox(height: 24),

                          // Participant Carousel - Figma Node 76:2208 (height: 104, item height: 96)
                          SizedBox(
                            height: 96,
                            child: _buildParticipantCarousel(),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // Spacer for Bottom Control Bar
                  SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 82,
                  ),
                ],
              ),
            ),
          ),

          // Top Header Bar - Figma Node 76:2229
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopHeaderBar(context),
          ),

          // Bottom Control Bar - Figma Node 76:2242
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControlBar(context),
          ),
        ],
      ),
    );
  }

  /// Top Header Bar (Figma Node 76:2229)
  Widget _buildTopHeaderBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.only(
            top: topPadding + 17,
            left: 17,
            right: 17,
            bottom: 17,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.05),
                offset: Offset(0, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back Button (Figma Node 76:2231)
              Material(
                color: Colors.transparent,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: const Key('live_classroom_back_button'),
                  onTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/parent/classes/${widget.classId}');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/icons/live_classroom_back.svg',
                      width: 16,
                      height: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Title, Subtitle, and LIVE Badge (Figma Node 76:2234)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title: Public Speaking: Module 3 (Node 76:2236)
                    Text(
                      'Public Speaking: Module 3',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF191C1E),
                        height: 32 / 24,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Subtitle: Communication Track (Node 76:2238)
                    Text(
                      'Communication Track',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF22D3EE),
                        height: 16 / 12,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // LIVE Badge (Node 76:2239)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2), // #fee2e2
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626), // #dc2626
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE',
                            style: GoogleFonts.hankenGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFB91C1C), // #b91c1c
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
      ),
    );
  }

  /// Main Stage (Teacher Video) - Figma Node 76:2193
  Widget _buildTeacherMainStage() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E3039),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, 4),
            blurRadius: 20,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Teacher Video Image Asset
          Image.asset(
            'assets/images/live_classroom_teacher.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),

          // Bottom Gradient Overlay + Overlay Info (Figma Node 76:2195)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(0, 0, 0, 0.6),
                    Color.fromRGBO(0, 0, 0, 0.0),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Teacher Name & Role (Figma Node 76:2196)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sarah Jenkins',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 24 / 16,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 1,
                              color: Color.fromRGBO(0, 0, 0, 0.06),
                            ),
                            Shadow(
                              offset: Offset(0, 4),
                              blurRadius: 1.5,
                              color: Color.fromRGBO(0, 0, 0, 0.07),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Instructor',
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 16 / 12,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 0.5,
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Pin & Fullscreen buttons (Figma Node 76:2201)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pin button (Figma Node 76:2202)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            color: Colors.white.withValues(alpha: 0.2),
                            child: SvgPicture.asset(
                              'assets/icons/live_classroom_pin.svg',
                              width: 7,
                              height: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Fullscreen button (Figma Node 76:2205)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(9999),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.white.withValues(alpha: 0.2),
                            child: SvgPicture.asset(
                              'assets/icons/live_classroom_fullscreen.svg',
                              width: 11,
                              height: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Participant Sidebar / Carousel - Figma Node 76:2208
  Widget _buildParticipantCarousel() {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      children: [
        // Student 1: You (Figma Node 76:2209)
        _buildParticipantCard(
          imageAsset: 'assets/images/live_classroom_student_you.png',
          name: 'You',
        ),
        const SizedBox(width: 12),

        // Student 2: Alex R. (Figma Node 76:2213)
        _buildParticipantCard(
          imageAsset: 'assets/images/live_classroom_student_alex.png',
          name: 'Alex R.',
          hasMutedMic: true,
        ),
        const SizedBox(width: 12),

        // Student 3: Mia S. (Figma Node 76:2219)
        _buildParticipantCard(
          imageAsset: 'assets/images/live_classroom_student_mia.png',
          name: 'Mia S.',
        ),
        const SizedBox(width: 12),

        // Student 4: +9 Others (Figma Node 76:2223)
        _buildOthersCard(),
      ],
    );
  }

  Widget _buildParticipantCard({
    required String imageAsset,
    required String name,
    bool hasMutedMic = false,
  }) {
    return Container(
      width: 128,
      height: 96,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Student Video
          Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),

          // Name Badge (Figma Overlay+OverlayBlur Node 76:2211, 76:2215, 76:2221)
          Positioned(
            left: 8,
            bottom: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 15 / 10,
                        ),
                      ),
                      if (hasMutedMic) ...[
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          'assets/icons/live_classroom_mic_muted.svg',
                          width: 8.25,
                          height: 8.58,
                        ),
                      ],
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

  /// Student 4: +9 Others (Figma Node 76:2223)
  Widget _buildOthersCard() {
    return Container(
      width: 128,
      height: 96,
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDF9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/live_classroom_users_more.svg',
            width: 27.5,
            height: 24,
          ),
          const SizedBox(height: 4),
          Text(
            '+9 Others',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF434655),
              height: 15 / 10,
            ),
          ),
        ],
      ),
    );
  }

  /// Bottom Control Bar - Figma Node 76:2242
  Widget _buildBottomControlBar(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: EdgeInsets.only(
            left: 17,
            right: 17,
            top: 17,
            bottom: bottomPadding + 17,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.04),
                offset: Offset(0, -4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Center/Left Controls: Mic Toggle + Camera Toggle (Figma Node 76:2243)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mic Toggle Button (Figma Node 76:2244)
                    Material(
                      color: _isMicOn ? const Color(0xFFEDEDF9) : const Color(0xFFFEE2E2),
                      shape: const CircleBorder(),
                      elevation: 1,
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.05),
                      child: InkWell(
                        key: const Key('live_classroom_mic_button'),
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setState(() {
                            _isMicOn = !_isMicOn;
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/live_classroom_mic_toggle.svg',
                            width: 14,
                            height: 19,
                            colorFilter: _isMicOn
                                ? null
                                : const ColorFilter.mode(
                                    Color(0xFFDC2626),
                                    BlendMode.srcIn,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Camera Toggle Button (Figma Node 76:2247)
                    Material(
                      color: _isCameraOn ? const Color(0xFFEDEDF9) : const Color(0xFFFEE2E2),
                      shape: const CircleBorder(),
                      elevation: 1,
                      shadowColor: const Color.fromRGBO(0, 0, 0, 0.05),
                      child: InkWell(
                        key: const Key('live_classroom_camera_button'),
                        customBorder: const CircleBorder(),
                        onTap: () {
                          setState(() {
                            _isCameraOn = !_isCameraOn;
                          });
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            'assets/icons/live_classroom_video_toggle.svg',
                            width: 20,
                            height: 16,
                            colorFilter: _isCameraOn
                                ? null
                                : const ColorFilter.mode(
                                    Color(0xFFDC2626),
                                    BlendMode.srcIn,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Leave Button (Figma Node 76:2251)
              Material(
                color: const Color(0xFFEF4444), // #ef4444
                borderRadius: BorderRadius.circular(9999),
                elevation: 1,
                shadowColor: const Color.fromRGBO(0, 0, 0, 0.05),
                child: InkWell(
                  key: const Key('live_classroom_leave_button'),
                  borderRadius: BorderRadius.circular(9999),
                  onTap: () {
                    // Navigate to Class Summary (Revised) in flow
                    context.go(
                      '/parent/classes/${widget.classId}/summary',
                      extra: widget.session,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    child: Text(
                      'Leave',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
