import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truelearn/core/error/failures.dart';
import 'package:truelearn/features/auth/data/models/auth_response.dart';
import 'package:truelearn/features/auth/presentation/controllers/auth_controller.dart';
import 'package:truelearn/features/auth/presentation/controllers/auth_state.dart';
import 'package:truelearn/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:truelearn/features/dashboard/domain/entities/child_entity.dart';
import 'package:truelearn/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:truelearn/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:truelearn/features/dashboard/presentation/screens/parent_dashboard_screen.dart';
import 'package:truelearn/features/dashboard/presentation/widgets/bento_snapshot_grid.dart';
import 'package:truelearn/features/dashboard/presentation/widgets/child_selector_row.dart';
import 'package:truelearn/features/dashboard/presentation/widgets/error_dashboard_widget.dart';
import 'package:truelearn/features/dashboard/presentation/widgets/featured_class_card.dart';
import 'package:truelearn/features/dashboard/presentation/widgets/my_learning_section.dart';

class FakeDashboardRepository implements DashboardRepository {
  List<ChildEntity> children = [];
  DashboardEntity? dashboard;
  Failure? failure;
  int childrenCallCount = 0;
  int dashboardCallCount = 0;

  @override
  Future<List<ChildEntity>> getLinkedChildren() async {
    childrenCallCount++;
    if (failure != null) throw failure!;
    return children;
  }

  @override
  Future<DashboardEntity> getChildDashboard({required String childStudentId}) async {
    dashboardCallCount++;
    if (failure != null) throw failure!;
    return dashboard ??
        const DashboardEntity(
          attendanceRate: 95.0,
          upcomingClassesCount: 3,
          pendingAssignmentsCount: 2,
          totalBalanceDue: 150.0,
        );
  }
}

class FakeAuthController extends AuthController {
  FakeAuthController(this._initialState);
  final AuthState _initialState;

  @override
  AuthState build() => _initialState;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late FakeDashboardRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeDashboardRepository();
  });

  Widget createTestWidget({
    AuthState authState = const Authenticated(
      accessToken: 'tok',
      user: UserDto(
        id: 'p1',
        email: 'parent@truelearn.com',
        role: 'PARENT',
        name: 'John Walker',
      ),
    ),
  }) {
    return ProviderScope(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(fakeRepo),
        authControllerProvider.overrideWith(() => FakeAuthController(authState)),
      ],
      child: const MaterialApp(
        home: ParentDashboardScreen(),
      ),
    );
  }

  testWidgets('renders pure frontend Figma 76:3476 Student Dashboard without backend calls', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // Verify error dashboard is never shown
    expect(find.byType(ErrorDashboardWidget), findsNothing);

    // Verify Child Selector strip (Figma Node 76:3579)
    expect(find.byType(ChildSelectorRow), findsOneWidget);
    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Mia'), findsOneWidget);

    // Verify Figma Greeting header (Node 76:3511)
    expect(find.text("Hi, Alex! Let's go on today's adventure!"), findsOneWidget);

    // Verify Featured Primary Card (Node 76:3513)
    expect(find.byType(FeaturedClassCard), findsOneWidget);
    expect(find.text("TODAY'S CLASS"), findsOneWidget);
    expect(find.text('Speaking with Confidence'), findsOneWidget);
    expect(find.text('Join Class'), findsOneWidget);

    // Verify My Learning section (Node 76:3530)
    expect(find.byType(MyLearningSection), findsOneWidget);
    expect(find.text('My Learning'), findsOneWidget);
    expect(find.text('Core Concepts & Basics'), findsOneWidget);
    expect(find.text('Understanding Feelings'), findsOneWidget);

    // Verify Bento Grid snapshot (Figma Node 76:3646)
    expect(find.byType(BentoSnapshotGrid), findsOneWidget);
    expect(find.text('Attendance'), findsOneWidget);
    expect(find.byKey(const Key('bento_attendance_card')), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
