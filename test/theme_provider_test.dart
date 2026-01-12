 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_ridebooking/provider/theme_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() => container.dispose());

  test('default theme is light', () {
    final theme = container.read(themeProvider);
    expect(theme, ThemeMode.light);
  });

  test('toggleTheme switches theme correctly', () {
    final notifier = container.read(themeProvider.notifier);

    notifier.toggleTheme();
    expect(container.read(themeProvider), ThemeMode.dark);

    notifier.toggleTheme();
    expect(container.read(themeProvider), ThemeMode.light);
  });

  test('setDark and setLight work', () {
    final notifier = container.read(themeProvider.notifier);

    notifier.setDark();
    expect(container.read(themeProvider), ThemeMode.dark);

    notifier.setLight();
    expect(container.read(themeProvider), ThemeMode.light);
  });
}
