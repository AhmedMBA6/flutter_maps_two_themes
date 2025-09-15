import 'package:flutter/material.dart';
import '../../../../constants/themes/app_colors.dart';

class HistoryItem extends StatelessWidget {
  final String query;

  const HistoryItem({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.history,
            color: AppColors.gray400,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              query,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.gray400,
              size: 16,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
