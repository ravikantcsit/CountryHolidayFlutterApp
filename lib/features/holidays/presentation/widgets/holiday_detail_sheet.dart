import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/holiday.dart';

/// Modal bottom sheet presenting full holiday metadata
class HolidayDetailSheet extends StatelessWidget {
  final Holiday holiday;

  const HolidayDetailSheet({
    super.key,
    required this.holiday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPublic = holiday.type == HolidayType.public;
    final typeColor =
        isPublic ? AppColors.publicHolidayColor : AppColors.schoolHolidayColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header with Icon
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPublic ? Icons.public : Icons.school,
                  color: typeColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holiday.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${isPublic ? "PUBLIC" : "SCHOOL"} HOLIDAY',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: typeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 32),

          // Date Range Row
          _DetailRow(
            icon: Icons.calendar_month,
            title: 'Date Range',
            value:
                '${holiday.startDate} to ${holiday.endDate} (${holiday.durationDays} day${holiday.durationDays > 1 ? "s" : ""})',
          ),
          const SizedBox(height: 16),

          // Coverage Scope Row
          _DetailRow(
            icon: Icons.location_on,
            title: 'Coverage',
            value: holiday.nationwide
                ? 'Nationwide Holiday'
                : 'Regional Holiday (${holiday.subdivisions.isNotEmpty ? holiday.subdivisions.join(", ") : "Specific States"})',
          ),

          // Comment / Notes (if available)
          if (holiday.comment != null && holiday.comment!.trim().isNotEmpty) ...[
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.notes,
              title: 'Comments',
              value: holiday.comment!,
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
