import 'package:flutter/material.dart';
import '../styles/app_theme.dart';
import '../styles/text_styles.dart';

class TestimonialCard extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;
  final String avatarUrl;
  final double width;

  const TestimonialCard({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    required this.avatarUrl,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelMd.withColor(AppColors.onSurface)),
                  Row(
                    children: List.generate(5, (idx) => Icon(
                      Icons.star,
                      size: 12,
                      color: idx < rating.floor() ? AppColors.secondaryFixedDim : AppColors.surfaceContainerHigh,
                    )),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            style: AppTextStyles.bodyMd.withColor(AppColors.onSurfaceVariant).copyWith(fontSize: 14),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
