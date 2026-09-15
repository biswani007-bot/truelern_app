import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:truelearn/core/theme/app_colors.dart';
import 'package:truelearn/core/theme/app_dimensions.dart';
import 'package:truelearn/core/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('AppTheme Tests', () {
    test('lightTheme can be instantiated with Material 3', () {
      final theme = AppTheme.lightTheme;
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.background);
    });

    test('colors match Figma design tokens', () {
      expect(AppColors.primary, const Color(0xFF0037B1));
      expect(AppColors.primaryDark, const Color(0xFF002B8C));
      expect(AppColors.slate900, const Color(0xFF0F172A));
      expect(AppColors.accentCyan, const Color(0xFF22D3EE));
      expect(AppColors.background, const Color(0xFFFAF8FF));
      expect(AppColors.surface, const Color(0xFFFFFFFF));
    });

    test('dimensions enforce Figma grid system', () {
      expect(AppDimensions.space8, 8.0);
      expect(AppDimensions.space16, 16.0);
      expect(AppDimensions.radius12, 12.0);
      expect(AppDimensions.radius16, 16.0);
      expect(AppDimensions.radius24, 24.0);
      expect(AppDimensions.radiusFull, 9999.0);
    });
  });
}
