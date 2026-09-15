import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:truelearn/core/error/failures.dart';
import 'package:truelearn/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:truelearn/features/dashboard/domain/entities/child_entity.dart';
import 'package:truelearn/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:truelearn/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:truelearn/features/dashboard/presentation/controllers/children_controller.dart';
import 'package:truelearn/features/dashboard/presentation/controllers/children_state.dart';

class FakeDashboardRepository implements DashboardRepository {
  List<ChildEntity> childrenToReturn = [];
  Failure? failureToThrow;
  int callCount = 0;

  @override
  Future<List<ChildEntity>> getLinkedChildren() async {
    callCount++;
    if (failureToThrow != null) {
      throw failureToThrow!;
    }
    return childrenToReturn;
  }

  @override
  Future<DashboardEntity> getChildDashboard({required String childStudentId}) async {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeDashboardRepository fakeRepo;
  late ProviderContainer container;

  setUp(() {
    fakeRepo = FakeDashboardRepository();
    container = ProviderContainer(
      overrides: [
        dashboardRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is ChildrenInitial', () {
    final state = container.read(childrenControllerProvider);
    expect(state, isA<ChildrenInitial>());
  });

  test('loadChildren emits ChildrenLoaded with children and selects first by default', () async {
    const child1 = ChildEntity(
      studentId: 'stud_1',
      firstName: 'Alice',
      lastName: 'Smith',
      grade: 'Grade 5',
    );
    const child2 = ChildEntity(
      studentId: 'stud_2',
      firstName: 'Bob',
      lastName: 'Smith',
      grade: 'Grade 3',
    );
    fakeRepo.childrenToReturn = [child1, child2];

    await container.read(childrenControllerProvider.notifier).loadChildren();

    final state = container.read(childrenControllerProvider);
    expect(state, isA<ChildrenLoaded>());
    final loaded = state as ChildrenLoaded;
    expect(loaded.children.length, 2);
    expect(loaded.activeChildId, 'stud_1');
    expect(loaded.activeChild?.firstName, 'Alice');
  });

  test('loadChildren emits ChildrenLoaded with empty list when parent has no children', () async {
    fakeRepo.childrenToReturn = [];

    await container.read(childrenControllerProvider.notifier).loadChildren();

    final state = container.read(childrenControllerProvider);
    expect(state, isA<ChildrenLoaded>());
    final loaded = state as ChildrenLoaded;
    expect(loaded.children, isEmpty);
    expect(loaded.activeChildId, isNull);
    expect(loaded.hasChildren, isFalse);
  });

  test('loadChildren emits ChildrenError on repository failure', () async {
    fakeRepo.failureToThrow = const ServerFailure('Backend unavailable');

    await container.read(childrenControllerProvider.notifier).loadChildren();

    final state = container.read(childrenControllerProvider);
    expect(state, isA<ChildrenError>());
    final error = state as ChildrenError;
    expect(error.message, contains('Backend unavailable'));
  });

  test('setActiveChild updates activeChildId when child exists', () async {
    const child1 = ChildEntity(studentId: 'stud_1', firstName: 'Alice');
    const child2 = ChildEntity(studentId: 'stud_2', firstName: 'Bob');
    fakeRepo.childrenToReturn = [child1, child2];

    await container.read(childrenControllerProvider.notifier).loadChildren();
    container.read(childrenControllerProvider.notifier).setActiveChild('stud_2');

    final state = container.read(childrenControllerProvider) as ChildrenLoaded;
    expect(state.activeChildId, 'stud_2');
    expect(state.activeChild?.firstName, 'Bob');
  });

  test('setActiveChild ignores non-existent child ID', () async {
    const child1 = ChildEntity(studentId: 'stud_1', firstName: 'Alice');
    fakeRepo.childrenToReturn = [child1];

    await container.read(childrenControllerProvider.notifier).loadChildren();
    container.read(childrenControllerProvider.notifier).setActiveChild('non_existent');

    final state = container.read(childrenControllerProvider) as ChildrenLoaded;
    expect(state.activeChildId, 'stud_1');
  });

  test('retry invokes loadChildren again', () async {
    fakeRepo.childrenToReturn = [
      const ChildEntity(studentId: 'stud_1', firstName: 'Alice'),
    ];

    await container.read(childrenControllerProvider.notifier).loadChildren();
    expect(fakeRepo.callCount, 1);

    await container.read(childrenControllerProvider.notifier).retry();
    expect(fakeRepo.callCount, 2);
  });
}
