import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('To-do app displays its home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TodoApp());

    await tester.pumpAndSettle();

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('Enter a task'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });
}