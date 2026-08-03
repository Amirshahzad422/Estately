import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:estately/main.dart';
import 'package:estately/providers/app_provider.dart';

void main() {
  testWidgets('Estately app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const EstatelyApp(),
      ),
    );
    expect(find.text('Estately'), findsWidgets);
  });
}
