import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/assignment_entity.dart';

/// Interactive UI state for the Assignment Submission screen.
enum SubmissionUiState {
  notStarted,
  draftSaved,
  submitting,
  submitted,
}

/// Assignment Submission Screen matching Figma Frame 76:2474 ("Assignment Submission (Revised)")
///
/// Features:
/// 1. Top App Bar with back navigation arrow and "Assignment" title
/// 2. Header Section with topic icon (puzzle), topic pill ("Practical Thinking"),
///    title ("Design a Rube\nGoldberg Machine"), and due date ("Due: Friday, 11:59 PM")
/// 3. Interactive state transitions between:
///    - State 1: Not Started (dashed upload dropzone)
///    - State 2: Draft Saved (attached file pill with delete icon, "Replace" & "Submit Now" CTAs)
///    - State 3: Submitting (animated progress indicator & percentage)
///    - State 4: Submitted (green celebration badge, success message, submitted file with "View" CTA)
/// 4. Also displays all 4 Figma state variations for comprehensive design fidelity,
///    or allows live interactive switching between them.
class AssignmentSubmissionScreen extends StatefulWidget {
  final String? assignmentId;
  final AssignmentEntity? assignment;
  final bool showAllStatesOverview;

  const AssignmentSubmissionScreen({
    super.key,
    this.assignmentId,
    this.assignment,
    this.showAllStatesOverview = true,
  });

  @override
  State<AssignmentSubmissionScreen> createState() => _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState extends State<AssignmentSubmissionScreen> {
  SubmissionUiState _currentState = SubmissionUiState.notStarted;
  double _uploadProgress = 0.67;
  Timer? _submissionTimer;
  String _currentFileName = 'my_rube_goldberg_plan.pdf';
  String _currentFileSize = '2.4 MB';

  @override
  void dispose() {
    _submissionTimer?.cancel();
    super.dispose();
  }

  void _onUploadFile() {
    setState(() {
      _currentState = SubmissionUiState.draftSaved;
      _currentFileName = 'my_rube_goldberg_plan.pdf';
      _currentFileSize = '2.4 MB';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File "my_rube_goldberg_plan.pdf" selected as draft.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onReplaceFile() {
    setState(() {
      _currentState = SubmissionUiState.draftSaved;
      _currentFileName = 'updated_goldberg_plan_v2.pdf';
      _currentFileSize = '3.1 MB';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Replaced with "updated_goldberg_plan_v2.pdf".'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onDeleteFile() {
    setState(() {
      _currentState = SubmissionUiState.notStarted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft file removed.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onSubmitNow() {
    setState(() {
      _currentState = SubmissionUiState.submitting;
      _uploadProgress = 0.20;
    });

    _submissionTimer?.cancel();
    _submissionTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _uploadProgress += 0.25;
        if (_uploadProgress >= 1.0) {
          _uploadProgress = 1.0;
          timer.cancel();
          _currentState = SubmissionUiState.submitted;
          try {
            context.go(
              '/parent/assignments/${widget.assignmentId}/submitted',
              extra: widget.assignment,
            );
          } catch (_) {
            // Context without GoRouter (e.g. unit/widget testing)
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.assignment?.title ?? 'Design a Rube\nGoldberg Machine';
    final topic = widget.assignment?.topic ?? 'Practical Thinking';
    final dueDate = widget.assignment?.dueDate ?? 'Due: Friday, 11:59 PM';

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient matching TrueLern design system
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
            child: Column(
              children: [
                // Top Header (Figma Node 76:2498)
                _buildTopHeader(context),

                // Main Scrollable Area
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 96),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 448),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section (Figma Node 76:2507)
                            _buildHeaderSection(topic, title, dueDate),
                            const SizedBox(height: 24),

                            // If showAllStatesOverview is true, render all 4 cards exactly as designed in Figma Frame 76:2474
                            if (widget.showAllStatesOverview) ...[
                              _buildState1NotStartedCard(),
                              const SizedBox(height: 24),
                              _buildState2DraftSavedCard(),
                              const SizedBox(height: 24),
                              _buildState3SubmittingCard(),
                              const SizedBox(height: 24),
                              _buildState4SubmittedCard(),
                            ] else ...[
                              // Single dynamic interactive card
                              _buildDynamicActiveStateCard(),
                            ],
                          ],
                        ),
                      ),
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

  /// Top Header Bar (Figma Node 76:2498)
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button (Node 76:2500)
          InkWell(
            key: const Key('submission_back_button'),
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/parent/assignments');
              }
            },
            borderRadius: BorderRadius.circular(9999),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/icons/submission_arrow_back.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(Color(0xFF191C1E), BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Title (Node 76:2504)
          Text(
            'Assignment',
            style: GoogleFonts.hankenGrotesk(
              fontSize: 25.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191C1E),
              height: 32 / 24,
            ),
          ),
        ],
      ),
    );
  }

  /// Assignment Header Section (Node 76:2507)
  Widget _buildHeaderSection(String topic, String title, String dueDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container: Purple rounded overlay with puzzle icon (Node 76:2508)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFA855F7).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/submission_puzzle.svg',
                width: 28.5,
                height: 30,
                colorFilter: const ColorFilter.mode(Color(0xFFA855F7), BlendMode.srcIn),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Text Details (Node 76:2511)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topic Pill (Node 76:2512)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    topic,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFA855F7),
                      height: 16 / 12,
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Assignment Title (Node 76:2516)
                Text(
                  title,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1B23),
                    height: 36 / 28,
                  ),
                ),
                const SizedBox(height: 4),

                // Due Date (Node 76:2518)
                Text(
                  dueDate,
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF747686),
                    height: 20 / 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // STATE 1: NOT STARTED CARD (Figma Node 76:2520)
  // ==========================================
  Widget _buildState1NotStartedCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 76:2522)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Upload Submission',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 28 / 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Not Started Pill (Node 76:2525)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E7F3),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'Not Started',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF747686),
                    height: 16 / 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Dashed Upload Dropzone (Node 76:2527)
          InkWell(
            key: const Key('tap_to_upload_box'),
            onTap: _onUploadFile,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: DashedBorder(
                  color: const Color(0xFFC4C5D7),
                  strokeWidth: 2,
                  dashPattern: const [6, 4],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cloud Upload Icon (Node 76:2529)
                  SvgPicture.asset(
                    'assets/icons/submission_cloud_upload.svg',
                    width: 33,
                    height: 24,
                    colorFilter: const ColorFilter.mode(Color(0xFF747686), BlendMode.srcIn),
                  ),
                  const SizedBox(height: 16),

                  // Tap to upload file (Node 76:2533)
                  Text(
                    'Tap to upload file',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1B23),
                      height: 24 / 16,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Supported formats description (Node 76:2534)
                  Text(
                    'Supported formats: PDF, DOCX, JPG\n(Max 10MB)',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF747686),
                      height: 20 / 14,
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

  // ==========================================
  // STATE 2: DRAFT SAVED CARD (Figma Node 76:2536)
  // ==========================================
  Widget _buildState2DraftSavedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xFF4F46E5), width: 4),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 25, 25, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 76:2538)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Upload Submission',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 28 / 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Draft Saved Pill (Node 76:2541)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/submission_check_purple.svg',
                      width: 12,
                      height: 12,
                      colorFilter: const ColorFilter.mode(Color(0xFF4F46E5), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Draft Saved',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF4F46E5),
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // File Card Box (Node 76:2546)
          Container(
            height: 81,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F2FE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC4C5D7).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // File Type Icon Box (Node 76:2548)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E7F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/submission_file_blue.svg',
                      width: 16,
                      height: 20,
                      colorFilter: const ColorFilter.mode(Color(0xFF4F46E5), BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // File Name & Size (Node 76:2551)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currentFileName,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1B23),
                          height: 24 / 16,
                        ),
                      ),
                      Text(
                        _currentFileSize,
                        style: GoogleFonts.hankenGrotesk(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF747686),
                          height: 20 / 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Trash Delete Icon (Node 76:2556)
                IconButton(
                  key: const Key('delete_draft_file_button'),
                  onPressed: _onDeleteFile,
                  icon: SvgPicture.asset(
                    'assets/icons/submission_trash.svg',
                    width: 16,
                    height: 18,
                    colorFilter: const ColorFilter.mode(Color(0xFF747686), BlendMode.srcIn),
                  ),
                  tooltip: 'Delete Draft',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons Row: Replace & Submit Now (Node 76:2559)
          Row(
            children: [
              // Replace Button (Node 76:2560)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    key: const Key('replace_file_button'),
                    onPressed: _onReplaceFile,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0037B1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Replace',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0037B1),
                        height: 24 / 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Submit Now Button (Node 76:2562)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    key: const Key('submit_now_button'),
                    onPressed: _onSubmitNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0037B1),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.black.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit Now',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 24 / 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  // ==========================================
  // STATE 3: SUBMITTING CARD (Figma Node 76:2565)
  // ==========================================
  Widget _buildState3SubmittingCard() {
    final pct = (_uploadProgress * 100).toInt();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xFF22D3EE), width: 4),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 25, 25, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 76:2567)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Upload Submission',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 28 / 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Submitting Pill (Node 76:2570)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22D3EE).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/submission_refresh_cyan.svg',
                      width: 10.6,
                      height: 10.6,
                      colorFilter: const ColorFilter.mode(Color(0xFF22D3EE), BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Submitting...',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF22D3EE),
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Uploading Progress Box (Node 76:2574)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F2FE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFC4C5D7).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cyan Circular Spinner Indicator (Node 76:2575)
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    value: _uploadProgress.clamp(0.0, 1.0),
                    strokeWidth: 3.5,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22D3EE)),
                    backgroundColor: const Color(0xFFE2E1ED),
                  ),
                ),
                const SizedBox(height: 16),

                // Uploading file... title (Node 76:2578)
                Text(
                  'Uploading file...',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 24 / 16,
                  ),
                ),
                const SizedBox(height: 12),

                // Cyan Progress Bar (Node 76:2579)
                Container(
                  width: 200,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E1ED),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: _uploadProgress.clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF22D3EE),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Progress percent (Node 76:2582)
                Text(
                  '$pct% complete',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF747686),
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

  // ==========================================
  // STATE 4: SUBMITTED SUCCESS CARD (Figma Node 76:2583)
  // ==========================================
  Widget _buildState4SubmittedCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('submitted_card_link'),
        onTap: () {
          try {
            context.go(
              '/parent/assignments/${widget.assignmentId}/submitted',
              extra: widget.assignment,
            );
          } catch (_) {}
        },
        child: Container(
          decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: Color(0xFF10B981), width: 4),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(24, 25, 25, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Node 76:2585)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Submission Status',
                  style: GoogleFonts.hankenGrotesk(
                    fontSize: 21.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1B23),
                    height: 28 / 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Submitted Badge (Node 76:2588)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/submission_check_white.svg',
                      width: 13.3,
                      height: 13.3,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Submitted',
                      style: GoogleFonts.hankenGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 16 / 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Big Green Checkmark Icon (Node 76:2594)
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/submission_check_green_big.svg',
                  width: 30,
                  height: 30,
                  colorFilter: const ColorFilter.mode(Color(0xFF10B981), BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Great job! Title (Node 76:2599)
          Center(
            child: Text(
              'Great job!',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1B23),
                height: 24 / 16,
              ),
            ),
          ),
          const SizedBox(height: 4),

          // Confirmation Text (Node 76:2602)
          Center(
            child: Text(
              'Your assignment was submitted on time at 10:42\nAM.',
              textAlign: TextAlign.center,
              style: GoogleFonts.hankenGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF747686),
                height: 20 / 14,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Submitted File Pill with "View" CTA (Node 76:2603)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFC4C5D7).withValues(alpha: 0.2),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/submission_file_blue_small.svg',
                        width: 16,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Color(0xFF0037B1), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'final_project_v2.pdf',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.hankenGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1B23),
                            height: 20 / 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  key: const Key('view_submitted_file_button'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening "final_project_v2.pdf" viewer...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View',
                    style: GoogleFonts.hankenGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0037B1),
                      height: 16 / 12,
                    ),
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

  /// Dynamic single active state card for interactive mode
  Widget _buildDynamicActiveStateCard() {
    switch (_currentState) {
      case SubmissionUiState.notStarted:
        return _buildState1NotStartedCard();
      case SubmissionUiState.draftSaved:
        return _buildState2DraftSavedCard();
      case SubmissionUiState.submitting:
        return _buildState3SubmittingCard();
      case SubmissionUiState.submitted:
        return _buildState4SubmittedCard();
    }
  }
}

/// Custom Dashed Border Painter for the dropzone
class DashedBorder extends BoxBorder {
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;

  const DashedBorder({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashPattern = const [6.0, 4.0],
  });

  @override
  BorderSide get top => BorderSide(color: color, width: strokeWidth);
  @override
  BorderSide get bottom => BorderSide(color: color, width: strokeWidth);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(strokeWidth);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = borderRadius != null
        ? borderRadius.toRRect(rect.deflate(strokeWidth / 2))
        : RRect.fromRectAndRadius(rect.deflate(strokeWidth / 2), Radius.zero);

    final path = Path()..addRRect(rrect);
    final dashedPath = _createDashedPath(path, dashPattern);
    canvas.drawPath(dashedPath, paint);
  }

  Path _createDashedPath(Path source, List<double> pattern) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var patternIndex = 0;
      while (distance < metric.length) {
        final len = pattern[patternIndex % pattern.length];
        final draw = patternIndex % 2 == 0;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        patternIndex++;
      }
    }
    return dest;
  }

  @override
  ShapeBorder scale(double t) => DashedBorder(
        color: color,
        strokeWidth: strokeWidth * t,
        dashPattern: dashPattern.map((e) => e * t).toList(),
      );
}
