import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/class_entity.dart';

/// SCR-16 Joining Class Screen (Figma Node 76:3263 "Joining Class (Revised)")
///
/// Linear transactional loading state transitioning from Class Preview into the
/// live classroom observation room.
/// Suppressed TopAppBar and BottomNavBar as specified in Figma design specs.
class JoiningClassScreen extends StatefulWidget {
  final String classId;
  final ClassEntity? session;

  const JoiningClassScreen({
    super.key,
    required this.classId,
    this.session,
  });

  @override
  State<JoiningClassScreen> createState() => _JoiningClassScreenState();
}

class _JoiningClassScreenState extends State<JoiningClassScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(begin: 0.25, end: 0.85).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.session?.title ?? 'Public Speaking Fundamentals';

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Stack(
            children: [
              // Subtle back/close button in top corner for parent convenience
              Positioned(
                top: 12,
                left: 16,
                child: IconButton(
                  key: const Key('joining_class_back_button'),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xFF434655),
                    size: 20,
                  ),
                  tooltip: 'Cancel & Return',
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/parent/classes/${widget.classId}');
                    }
                  },
                ),
              ),

              // Main Centered Content (Figma Frame 76:3264)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Large 3D Icon Container (Figma Nodes 76:3276 -> 76:3282)
                        _buildClayMicIcon(),
                        const SizedBox(height: 32),

                        // Heading 1 (Figma Nodes 76:3266, 76:3267)
                        Text(
                          'Joining your class...',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1B23),
                            height: 36 / 28,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle - Class Title (Figma Nodes 76:3269, 76:3270)
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF434655),
                            height: 24 / 16,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Progress Indicator (Figma Nodes 76:3271 -> 76:3275)
                        _buildProgressIndicator(),
                      ],
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

  /// Builds the 3D simulated clay icon card for Communication/Public Speaking (Figma 76:3276)
  Widget _buildClayMicIcon() {
    return Container(
      width: 192,
      height: 192,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(34, 211, 238, 0.1), // rgba(34, 211, 238, 0.1)
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 20),
              blurRadius: 25,
              spreadRadius: -5,
            ),
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 8),
              blurRadius: 10,
              spreadRadius: -6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Diagonal soft cyan gradient (Figma 76:3281)
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromRGBO(34, 211, 238, 0.2), // rgba(34, 211, 238, 0.2)
                        Color.fromRGBO(34, 211, 238, 0.0), // rgba(34, 211, 238, 0)
                      ],
                    ),
                  ),
                ),
              ),

              // Decorative 3D highlight bubble in top right (Figma 76:3282)
              Positioned(
                top: 8,
                right: 8,
                width: 32,
                height: 32,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.8),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Centered Mic Vector Icon (Figma 76:3280)
              Center(
                child: SvgPicture.asset(
                  'assets/icons/mic_joining.svg',
                  width: 35,
                  height: 47.5,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the Progress Bar & Status Text (Figma 76:3271)
  Widget _buildProgressIndicator() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Track + Indicator (Figma 76:3272, 76:3273)
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E1ED),
            borderRadius: BorderRadius.circular(9999),
          ),
          clipBehavior: Clip.antiAlias,
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF22D3EE), // Figma cyan #22D3EE
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Text (Figma 76:3275)
        Text(
          'Connecting to virtual classroom...',
          textAlign: TextAlign.center,
          style: GoogleFonts.hankenGrotesk(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF434655),
            height: 16 / 12,
          ),
        ),
        const SizedBox(height: 32),

        // Enter Virtual Classroom Trigger (SCR Live Classroom New)
        TextButton.icon(
          key: const Key('enter_live_classroom_trigger_button'),
          icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: Color(0xFF0037B1)),
          label: Text(
            'Enter Classroom →',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0037B1),
            ),
          ),
          onPressed: () {
            context.go(
              '/parent/classes/${widget.classId}/live',
              extra: widget.session,
            );
          },
        ),
      ],
    );
  }
}

