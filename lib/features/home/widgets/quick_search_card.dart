import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_routes.dart';
import '../../../core/widgets/custom_button.dart';

/// Quick Search section on the dashboard for instant route and date queries.
class QuickSearchCard extends StatefulWidget {
  const QuickSearchCard({super.key});

  @override
  State<QuickSearchCard> createState() => _QuickSearchCardState();
}

class _QuickSearchCardState extends State<QuickSearchCard> {
  final _leavingFromController = TextEditingController(
    text: 'Koramangala, Bengaluru',
  );
  final _goingToController = TextEditingController(
    text: 'Whitefield Tech Park',
  );
  String _selectedDate = 'Today, 12 Nov';

  @override
  void dispose() {
    _leavingFromController.dispose();
    _goingToController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    final temp = _leavingFromController.text;
    setState(() {
      _leavingFromController.text = _goingToController.text;
      _goingToController.text = temp;
    });
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      setState(() {
        _selectedDate = '${picked.day} ${months[picked.month - 1]}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.saved_search_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Ride Search',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Route Inputs with Swap Icon
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Leaving From
                    _buildInputField(
                      controller: _leavingFromController,
                      icon: Icons.my_location_rounded,
                      iconColor: AppColors.primary,
                      hintText: 'Leaving From',
                    ),
                    const Divider(height: 12),
                    // Going To
                    _buildInputField(
                      controller: _goingToController,
                      icon: Icons.location_on_rounded,
                      iconColor: AppColors.error,
                      hintText: 'Going To',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _swapLocations,
                icon: const Icon(Icons.swap_vert_rounded),
                color: AppColors.primary,
                tooltip: 'Swap locations',
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Travel Date Selector
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel Date',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        _selectedDate,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppConstants.defaultPadding),

          // Search Rides Button
          CustomButton(
            text: 'Search Rides',
            icon: Icons.search_rounded,
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.findRide);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String hintText,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),
        ),
      ],
    );
  }
}
