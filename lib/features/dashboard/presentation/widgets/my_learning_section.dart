import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

/// My Learning Section matching Figma Node 58:1377 (Student Dashboard).
class MyLearningSection extends StatelessWidget {
  const MyLearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'My Learning',
            style: AppTypography.titleMedium.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1B23),
            ),
          ),
        ),
        // Course Card 1 (Figma Node 58:1381)
        const _CourseCard(
          icon: Icons.menu_book_rounded,
          iconColor: Color(0xFF14B8A6), // #14b8a6
          iconBg: Color(0x1A14B8A6), // rgba(20, 184, 166, 0.1)
          statusPill: 'Junior Foundation',
          title: 'Core Concepts & Basics',
          progressPercent: 0.65,
          completedText: 'Progress',
          percentageText: '65%',
          scheduleText: 'Next class Tomorrow',
        ),
        const SizedBox(height: 12),
        // Course Card 2 (Figma Node 58:1402)
        const _CourseCard(
          icon: Icons.lightbulb_outline_rounded,
          iconColor: Color(0xFFFB7185), // #fb7185
          iconBg: Color(0x1AFB7185), // rgba(251, 113, 133, 0.1)
          statusPill: 'Emotional Intelligence',
          title: 'Understanding Feelings',
          progressPercent: 0.32,
          completedText: 'Progress',
          percentageText: '32%',
          scheduleText: 'Next class Friday',
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.statusPill,
    required this.title,
    required this.progressPercent,
    required this.completedText,
    required this.percentageText,
    required this.scheduleText,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String statusPill;
  final String title;
  final double progressPercent;
  final String completedText;
  final String percentageText;
  final String scheduleText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x80E2E1ED), width: 1), // rgba(226, 225, 237, 0.5)
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), // rgba(0, 0, 0, 0.04)
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  statusPill,
                  style: AppTypography.labelSmall.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.titleMedium.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1B23),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                completedText,
                style: AppTypography.labelSmall.copyWith(
                  color: const Color(0xFF434655),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Text(
                percentageText,
                style: AppTypography.labelSmall.copyWith(
                  color: iconColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: const Color(0xFFF1F5F9), // #f1f5f9
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: Color(0xFF434655),
              ),
              const SizedBox(width: 6),
              Text(
                scheduleText,
                style: AppTypography.bodySmall.copyWith(
                  color: const Color(0xFF434655),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
