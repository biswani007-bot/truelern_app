import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../dashboard/domain/entities/child_entity.dart';
import '../../domain/entities/class_entity.dart';
import '../widgets/classes_date_navigator.dart';
import '../widgets/classes_event_card.dart';
import '../widgets/classes_filter_tabs.dart';
import '../widgets/classes_student_selector.dart';
import '../widgets/empty_classes_widget.dart';

/// Parent Classes Schedule Screen — PURE FRONTEND PRESENTATION ONLY.
///
/// Figma Source of Truth: Parent(full app)_TreLern, Frame 76:1820.
///
/// STRICT RULES:
/// - NO backend calls. NO API fetches.
/// - Static data from Figma: Alex (Age 9), Mia (Age 12), static classes.
class ParentClassesScreen extends ConsumerStatefulWidget {
  const ParentClassesScreen({super.key});

  @override
  ConsumerState<ParentClassesScreen> createState() => _ParentClassesScreenState();
}

class _ParentClassesScreenState extends ConsumerState<ParentClassesScreen> {
  // Figma Frame 76:1820: Wed 26 selected
  DateTime _selectedDate = DateTime(2026, 8, 26);
  String _selectedFilter = 'Upcoming';

  // Static Figma-accurate children — Alex (Age 9) and Mia (Age 12) only.
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

  int _activeChildIndex = 0;
  ChildEntity get _activeChild => _figmaChildren[_activeChildIndex];

  // Static Figma-accurate classes — no API fetching.
  static final _figmaClasses = [
    ClassEntity(
      id: 'fb_1',
      title: 'Public Speaking Workshop',
      subject: 'Communication & Confidence',
      status: 'UPCOMING',
      scheduledStartTime: DateTime(2026, 8, 26, 16, 0),
      scheduledEndTime: DateTime(2026, 8, 26, 17, 0),
      teacherName: 'Ms. Sarah',
    ),
    ClassEntity(
      id: 'fb_2',
      title: 'Creative Thinking Demo',
      subject: 'Junior Foundation',
      status: 'UPCOMING',
      scheduledStartTime: DateTime(2026, 8, 27, 10, 0),
      scheduledEndTime: DateTime(2026, 8, 27, 11, 0),
      teacherName: 'Ms. Sarah',
    ),
  ];

  Future<void> _onRefresh() async {
    // No-op — pure frontend presentation, no backend refresh.
  }

  @override
  Widget build(BuildContext context) {
    // Static data only — no ref.watch/listen to any backend-backed provider.
    final allClasses = _figmaClasses;
    List<ClassEntity> filteredClasses;
    if (_selectedDate.year == 2026 && _selectedDate.month == 8 && _selectedDate.day == 26) {
      // Default Figma Frame 76:1820 view on Wed Aug 26 displays upcoming schedule
      filteredClasses = allClasses;
    } else {
      filteredClasses = allClasses.where((c) {
        final start = c.scheduledStartTime;
        if (start == null) return false;
        return start.year == _selectedDate.year &&
            start.month == _selectedDate.month &&
            start.day == _selectedDate.day;
      }).toList();
    }

    if (_selectedFilter.toLowerCase() == 'completed') {
      filteredClasses = filteredClasses.where((c) => c.isCompleted).toList();
    } else if (_selectedFilter.toLowerCase() == 'upcoming') {
      filteredClasses = filteredClasses.where((c) => !c.isCompleted).toList();
    } else if (_selectedFilter.toLowerCase() == 'cancelled') {
      filteredClasses = filteredClasses.where((c) => c.status?.toUpperCase() == 'CANCELLED').toList();
    } else if (_selectedFilter.toLowerCase() == 'missed') {
      filteredClasses = filteredClasses.where((c) => c.status?.toUpperCase() == 'MISSED').toList();
    }

    return Scaffold(
      key: const Key('parent_classes_screen'),
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
              _buildTopAppBar(context),
              Expanded(
                child: _buildScheduleView(
                  context,
                  classes: filteredClasses,
                  activeChild: _activeChild,
                  children: _figmaChildren,
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
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Hamburger Menu Button (Node 76:1822)
          IconButton(
            key: const Key('classes_menu_button'),
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF191C1E), size: 24),
            onPressed: () {
              Scaffold.maybeOf(context)?.openDrawer();
            },
            tooltip: 'Menu',
          ),

          // Center: My Classes Title (Node 76:1825 / 76:1826)
          Text(
            'My Classes',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 25.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF191C1E),
              letterSpacing: -0.5,
            ),
          ),

          // Right: Filter / Preferences Icon Button (Node 76:1827)
          IconButton(
            key: const Key('classes_filter_icon_button'),
            icon: const Icon(Icons.tune_rounded, color: Color(0xFF191C1E), size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter settings coming soon.'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Filter',
          ),
        ],
      ),
    );
  }


  Widget _buildScheduleView(
    BuildContext context, {
    required List<ClassEntity> classes,
    required ChildEntity? activeChild,
    required List<ChildEntity> children,
  }) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF0037B1),
      child: CustomScrollView(
        key: const Key('classes_scroll_view'),
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Student Selector (Node 76:1831)
                  if (activeChild != null)
                    ClassesStudentSelector(
                      activeChild: activeChild,
                      children: children,
                      onChildSelected: (newId) {
                        final idx = _figmaChildren.indexWhere(
                          (c) => c.studentId == newId,
                        );
                        if (idx != -1) setState(() => _activeChildIndex = idx);
                      },
                    ),
                  const SizedBox(height: 16),

                  // 2. Date Navigator Strip (Node 76:1837)
                  ClassesDateNavigator(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Filter Tabs (Node 76:1880)
                  ClassesFilterTabs(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (filter) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // 4. Illustration Header (Node 76:1890)
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: Image.asset(
                      'assets/images/figma_cal_single.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.calendar_month_rounded,
                        size: 96,
                        color: Color(0xFF0037B1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Heading: Upcoming Events (Node 76:1894 / 76:1895)
                  Text(
                    'Upcoming Events',
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 25.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 5. Events List (Node 76:1896)
          if (classes.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: EmptyClassesWidget(
                  childName: activeChild?.firstName,
                  onRefresh: _onRefresh,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final session = classes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClassesEventCard(
                        session: session,
                        useThinkingIcon: index.isOdd,
                        onTap: () {
                          try {
                            GoRouter.of(context).push(
                              '/parent/classes/${session.id}',
                              extra: session,
                            );
                          } catch (_) {
                            // Fallback if rendered outside GoRouter (e.g. isolated test harness)
                          }
                        },
                      ),
                    );
                  },
                  childCount: classes.length,
                ),
              ),
            ),

          // 6. Explore Programs Button (Node 76:1918)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Center(
                child: OutlinedButton(
                  key: const Key('explore_programs_button'),
                  onPressed: () {
                    context.push('/parent/classes/program');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0037B1),
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFF0037B1),
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                    shadowColor: Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Text(
                    'Explore Programs',
                    style: AppTypography.labelLarge.copyWith(
                      color: const Color(0xFF0037B1),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
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
}
