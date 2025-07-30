import 'package:flutter/material.dart';
import '../../../constants/themes/app_text_styles.dart';

class TryDifferentPhoneLink extends StatelessWidget {
  final VoidCallback onTryDifferentPhone;

  const TryDifferentPhoneLink({
    super.key,
    required this.onTryDifferentPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Didn't receive the code? Check your messages or ",
        style: AppTextStyles.bodyMediumThemed(context),
        children: [
          WidgetSpan(
            child: GestureDetector(
              onTap: onTryDifferentPhone,
              child: Text(
                'try a different phone number',
                style: AppTextStyles.linkThemed(context),
              ),
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
} 