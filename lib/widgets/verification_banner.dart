import 'package:flutter/material.dart';

class VerificationBanner extends StatelessWidget {
  final String status;

  const VerificationBanner({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == "scientifically_verified") {
      return const SizedBox.shrink();
    }

    Color color;
    String text;

    if (status == "community_verified") {
      color = Colors.orange;
      text =
          "Community-verified information. Effectiveness may vary based on conditions.";
    } else {
      color = Colors.red;
      text =
          "Not verified. This information may be inaccurate. Do not rely on it for critical or safety-related decisions.";
    }

    return Container(
      padding: const EdgeInsets.all(8),
      color: color.withAlpha(25), // roughly 0.1 * 255
      child: Row(
        children: [
          Icon(Icons.warning, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
