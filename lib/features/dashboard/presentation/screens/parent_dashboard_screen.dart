import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../classes/domain/entities/class_entity.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/child_entity.dart';
import '../widgets/bento_snapshot_grid.dart';
import '../widgets/child_selector_row.dart';
import '../widgets/featured_class_card.dart';
import '../widgets/my_learning_section.dart';

/// Student Dashboard Screen — PURE FRONTEND PRESENTATION ONLY.
///
/// Figma Source of Truth: Parent(full app)_TreLern, Frame 76:3476.
///
/// STRICT RULES:
/// - NO backend calls. NO ref.watch/listen to any repository-backed provider.
/// - ALL data is statically derived from Figma Node 76:3476.
/// - Children: Alex (Age 9) and Mia (Age 12) — EXACTLY as shown in Figma.
/// - No "Ethan" or any other child not present in Figma.
class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() =>
      _ParentDashboardScreenState();
}

class _ParentDashboardScreenState
    extends ConsumerState<ParentDashboardScreen> {

  // Static Figma-accurate children (Node 76:3579) — EXACTLY Alex + Mia.
  static const _figmaChildren = [
    ChildEntity(
      studentId: 'alex_1',
      firstName: 'Alex',
      lastName: '',
      grade: 'Age 9',
    ),
    ChildEntity(
      studentId: 'mia_2',
      firstName: 'Mia',
      lastName: '',
      grade: 'Age 12',
    ),
  ];

  // Active child selection — local UI state only, no backend.
  int _activeChildIndex = 0;
  ChildEntity get _activeChild => _figmaChildren[_activeChildIndex];

  Future<void> _onRefresh() async {
    // No-op — pure frontend presentation, no backend refresh.
  }

  @override
  Widget build(BuildContext context) {
    // ── Static Figma data — NO provider watches ─────────────────────────────
    const upcomingClass = ClassEntity(
      id: 'mock_speaking_1',
      title: 'Speaking with Confidence',
      subject: 'Communication & Public Speaking',
      teacherName: 'Ms. Sarah',
      status: 'UPCOMING',
      scheduledStartTime: null,
      scheduledEndTime: null,
    );

    const dashboard = DashboardEntity(
      attendanceRate: 72.0,
      upcomingClassesCount: 3,
      pendingAssignmentsCount: 2,
      totalBalanceDue: 0.0,
    );

    return Scaffold(
      key: const Key('parent_dashboard_screen'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF3E8FF),
              Color(0xFFE0F2FE),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header — Figma Node 76:3501
              _buildTopAppBar(context),

              // Child Selector — Figma Node 76:3579 (static: Alex + Mia only)
              ChildSelectorRow(
                children: _figmaChildren,
                activeChildId: _activeChild.studentId,
                onSelectChild: (childId) {
                  final idx = _figmaChildren.indexWhere(
                    (c) => c.studentId == childId,
                  );
                  if (idx != -1) setState(() => _activeChildIndex = idx);
                },
              ),

              // Scrollable body
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: const Color(0xFF1E4ED8),
                  child: SingleChildScrollView(
                    key: const Key('dashboard_scroll_view'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Greeting — Figma Node 76:3511
                        Text(
                          'Hi, ${_activeChild.firstName}! Let\'s go on today\'s adventure!',
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A1B23),
                            letterSpacing: -0.5,
                            height: 1.28,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Featured Class Card — Figma Node 76:3513
                        FeaturedClassCard(
                          upcomingClass: upcomingClass,
                          onViewClass: () => context.go('/parent/classes'),
                        ),
                        const SizedBox(height: 24),

                        // My Learning Section — Figma Node 76:3530
                        const MyLearningSection(),
                        const SizedBox(height: 24),

                        // Bento Snapshot Grid — Figma Node 76:3646
                        BentoSnapshotGrid(
                          dashboard: dashboard,
                          activeTopic: 'Speaking With Confidence',
                        ),
                        const SizedBox(height: 32),
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

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hamburger Menu — Node 76:3502
          IconButton(
            key: const Key('dashboard_menu_button'),
            icon: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF1A1B23),
              size: 24,
            ),
            onPressed: () => Scaffold.maybeOf(context)?.openDrawer(),
            tooltip: 'Menu',
          ),

          // "Dashboard" title — Node 76:3505
          Text(
            'Dashboard',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1B23),
              letterSpacing: -0.5,
            ),
          ),

          // Notification Bell — Node 76:3507
          IconButton(
            key: const Key('dashboard_bell_button'),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF1E4ED8),
              size: 24,
            ),
            onPressed: () => context.go(AppRoutePaths.notifications),
            tooltip: 'Notifications',
          ),
        ],
      ),
    );
  }
}
