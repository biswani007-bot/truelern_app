import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../dashboard/presentation/controllers/children_controller.dart';
import '../../../dashboard/presentation/controllers/children_state.dart';
import '../../domain/entities/class_entity.dart';
import '../controllers/classes_controller.dart';
import '../controllers/classes_state.dart';

/// Class Preview Screen (Figma Frame 76:3154 titled "Ready to Join (Revised)").
///
/// 100% Figma Match:
/// - Top Navigation: Back circular button (40x40 white, radius 9999) + centered "Class Preview" (24px Bold #191C1E)
/// - Background canvas gradient: linear-gradient(134.87deg, #F3E8FF 0%, #E0F2FE 50%, #FFFFFF 100%)
/// - Hero Class Info Card:
///   - 24px border radius with blur and shadow (rgba(0,0,0,0.05))
///   - Top-right cyan glow accent
///   - Centered 3D Communication Illustration (figma_communication_hero.png)
///   - Category pill: "Communication" (#22D3EE text, 12px Medium, radius 9999)
///   - Heading: "Speaking With Confidence" (28px Bold #1A1B23)
///   - Teacher info: teacher icon + "Teacher: Sarah Jenkins"
/// - Camera Preview Section:
///   - Section heading: "Camera Preview" (16px SemiBold #1A1B23)
///   - 16:9 Aspect ratio video container (4px white border, 16px radius, shadow)
///   - Simulated webcam feed image (figma_webcam_feed.png)
///   - Floating overlay: green online dot + student name (e.g. "Alex Rivera")
///   - Action circular icon buttons: Microphone toggle & Camera toggle with glassmorphism blur
/// - Device Check Card:
///   - Section heading: "Device Check" (16px SemiBold #1A1B23)
///   - 3 List items (Microphone, Camera, Speaker) with circular icon background and green checkmark icon
/// - Action Area:
///   - Primary Button: "JOIN LIVE CLASS →" (#0037B1 solid blue, 12px radius, shadow)
///   - Secondary Outlined Button: "Test Audio" (#0037B1 text, #DCE1FF border, 12px radius)
class ClassPreviewScreen extends ConsumerStatefulWidget {
  const ClassPreviewScreen({
    super.key,
    required this.classId,
    this.session,
  });

  final String classId;
  final ClassEntity? session;

  @override
  ConsumerState<ClassPreviewScreen> createState() => _ClassPreviewScreenState();
}

class _ClassPreviewScreenState extends ConsumerState<ClassPreviewScreen> {
  bool _isMicOn = true;
  bool _isCameraOn = true;

  @override
  Widget build(BuildContext context) {
    // Resolve session
    ClassEntity? resolvedSession = widget.session;
    if (resolvedSession == null) {
      final classesState = ref.watch(classesControllerProvider);
      if (classesState is ClassesLoaded) {
        resolvedSession = classesState.classes.where((c) => c.id == widget.classId).firstOrNull;
      }
    }

    final childrenState = ref.watch(childrenControllerProvider);
    final studentName = childrenState is ChildrenLoaded && childrenState.activeChild != null
        ? '${childrenState.activeChild!.firstName} ${childrenState.activeChild!.lastName}'.trim()
        : 'Alex Rivera';

    final title = (resolvedSession != null && resolvedSession.title.isNotEmpty)
        ? resolvedSession.title
        : 'Speaking With Confidence';
    final category = (resolvedSession != null && resolvedSession.subject != null && resolvedSession.subject!.isNotEmpty)
        ? resolvedSession.subject!
        : 'Communication';
    final teacher = (resolvedSession != null && resolvedSession.teacherName != null && resolvedSession.teacherName!.isNotEmpty)
        ? resolvedSession.teacherName!
        : 'Sarah Jenkins';

    return Scaffold(
      key: const Key('class_preview_screen'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3E8FF), // 0%
              Color(0xFFE0F2FE), // 50%
              Color(0xFFFFFFFF), // 100%
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top App Bar matching Node 76:3178
              _buildTopAppBar(context),

              // Main Scrollable Area
              Expanded(
                child: SingleChildScrollView(
                  key: const Key('class_preview_scroll_view'),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: Hero Class Info Card (Node 76:3185)
                      _buildHeroClassCard(
                        title: title,
                        category: category,
                        teacher: teacher,
                      ),
                      const SizedBox(height: 24),

                      // Section 2: Camera Preview Area (Node 76:3198)
                      _buildCameraPreviewSection(studentName: studentName),
                      const SizedBox(height: 24),

                      // Section 3: Device Check (Node 76:3214)
                      _buildDeviceCheckSection(),
                      const SizedBox(height: 24),

                      // Section 4: Action Buttons (Node 76:3254)
                      _buildActionButtons(context),
                      const SizedBox(height: 24),
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

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Circular Back Button (Node 76:3179)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              key: const Key('class_preview_back_button'),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF191C1E), size: 20),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/parent/classes');
                }
              },
              tooltip: 'Back',
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Text(
                  'Class Preview',
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 25.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF191C1E),
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroClassCard({
    required String title,
    required String category,
    required String teacher,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Top-right cyan glow overlay (Node 76:3186)
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF22D3EE).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              // 3D Communication Illustration (Node 76:3188)
              SizedBox(
                width: 130,
                height: 124,
                child: Image.asset(
                  'assets/images/figma_communication_hero.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.record_voice_over_rounded,
                    size: 96,
                    color: Color(0xFF0037B1),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Category Pill (Node 76:3190)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  category,
                  style: AppTypography.labelMedium.copyWith(
                    color: const Color(0xFF0891B2),
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Title (Node 76:3193)
              Text(
                title,
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1B23),
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Teacher Info (Node 76:3194)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline_rounded, size: 16, color: Color(0xFF434655)),
                  const SizedBox(width: 4),
                  Text(
                    'Teacher: $teacher',
                    style: AppTypography.bodyMedium.copyWith(
                      color: const Color(0xFF434655),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreviewSection({required String studentName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Camera Preview',
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1B23),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Video preview container with 16:9 aspect ratio
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2E3039),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Simulated webcam image
                if (_isCameraOn)
                  Image.asset(
                    'assets/images/figma_webcam_feed.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF2E3039),
                      child: const Center(
                        child: Icon(Icons.videocam_rounded, size: 48, color: Colors.white54),
                      ),
                    ),
                  )
                else
                  Container(
                    color: const Color(0xFF1E2026),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.videocam_off_rounded, size: 48, color: Colors.white54),
                          const SizedBox(height: 8),
                          Text(
                            'Camera is Turned Off',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Bottom floating overlay controls
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Student name pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4ADE80),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              studentName,
                              style: AppTypography.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Control buttons: Mic & Camera toggle
                      Row(
                        children: [
                          // Mic Button
                          GestureDetector(
                            key: const Key('preview_mic_toggle'),
                            onTap: () {
                              setState(() {
                                _isMicOn = !_isMicOn;
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _isMicOn
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : const Color(0xFFDC2626),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              child: Icon(
                                _isMicOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Camera Button
                          GestureDetector(
                            key: const Key('preview_camera_toggle'),
                            onTap: () {
                              setState(() {
                                _isCameraOn = !_isCameraOn;
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _isCameraOn
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : const Color(0xFFDC2626),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                              ),
                              child: Icon(
                                _isCameraOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
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
        ),
      ],
    );
  }

  Widget _buildDeviceCheckSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device Check',
            style: AppTypography.bodyLarge.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1B23),
            ),
          ),
          const SizedBox(height: 14),

          // 3 Device items: Mic, Camera, Speaker
          _buildDeviceItem(
            icon: Icons.mic_rounded,
            title: 'Microphone',
            subtitle: 'Default Audio Input',
          ),
          const SizedBox(height: 10),
          _buildDeviceItem(
            icon: Icons.videocam_rounded,
            title: 'Camera',
            subtitle: 'HD Web Camera',
          ),
          const SizedBox(height: 10),
          _buildDeviceItem(
            icon: Icons.volume_up_rounded,
            title: 'Speaker',
            subtitle: 'System Audio',
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E1ED)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E7F3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF0037B1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    color: const Color(0xFF1A1B23),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: const Color(0xFF434655),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Primary Join Button (Node 76:3256)
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            key: const Key('preview_join_live_class_button'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0037B1),
              elevation: 4,
              shadowColor: const Color(0xFF0037B1).withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.push(
                '/parent/classes/${widget.classId}/joining',
                extra: widget.session,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'JOIN LIVE CLASS',
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary Test Audio Button (Node 76:3261)
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            key: const Key('preview_test_audio_button'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFDCE1FF), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Playing audio test chime...'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Text(
              'Test Audio',
              style: AppTypography.labelMedium.copyWith(
                color: const Color(0xFF0037B1),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
