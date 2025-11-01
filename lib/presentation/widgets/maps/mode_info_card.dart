import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/constants/widgets/utils.dart';

class RouteInfoCard extends StatelessWidget {
  final String distance;
  final String duration;

  const RouteInfoCard({
    super.key,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: formatDuration(duration),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(text: '• '),
                  TextSpan(
                    text: '$distance km',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
