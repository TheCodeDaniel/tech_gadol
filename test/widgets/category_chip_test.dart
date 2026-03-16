import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol/core/theme/light_theme.dart';
import 'package:tech_gadol/core/theme/dark_theme.dart';
import 'package:tech_gadol/core/widgets/category_chip.dart';

void main() {
  Widget buildWidget({String label = 'smart-phones', bool isSelected = false, VoidCallback? onTap, ThemeData? theme}) {
    return MaterialApp(
      theme: theme ?? LightTheme.themeData,
      home: Scaffold(
        body: CategoryChip(label: label, isSelected: isSelected, onTap: onTap ?? () {}),
      ),
    );
  }

  group('CategoryChip', () {
    testWidgets('displays formatted label from slug', (tester) async {
      await tester.pumpWidget(buildWidget(label: 'smart-phones'));
      expect(find.text('Smart Phones'), findsOneWidget);
    });

    testWidgets('displays single word label with capitalization', (tester) async {
      await tester.pumpWidget(buildWidget(label: 'electronics'));
      expect(find.text('Electronics'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));
      await tester.tap(find.byType(FilterChip));
      expect(tapped, true);
    });

    testWidgets('renders selected state', (tester) async {
      await tester.pumpWidget(buildWidget(isSelected: true));
      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, true);
    });

    testWidgets('renders unselected state', (tester) async {
      await tester.pumpWidget(buildWidget(isSelected: false));
      final chip = tester.widget<FilterChip>(find.byType(FilterChip));
      expect(chip.selected, false);
    });

    testWidgets('renders correctly in dark theme', (tester) async {
      await tester.pumpWidget(buildWidget(theme: DarkTheme.themeData));
      expect(find.text('Smart Phones'), findsOneWidget);
    });
  });
}
