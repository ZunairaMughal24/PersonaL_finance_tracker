import 'package:flutter/material.dart';
import 'package:montage/widgets/skeleton_loader.dart';
import 'package:montage/core/utils/widget_utility_extention.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics:
          const NeverScrollableScrollPhysics(), // Keep it static during load if desired, or allow scroll
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                const SkeletonLoader(width: 50, height: 50, borderRadius: 25),
                15.widthBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonLoader(width: 120, height: 20),
                    8.heightBox,
                    const SkeletonLoader(width: 180, height: 14),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLoader(width: 140, height: 28),
                20.heightBox,

                const SkeletonLoader(
                  width: double.infinity,
                  height: 160,
                  borderRadius: 24,
                ),
                20.heightBox,

                Row(
                  children: [
                    const Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 20,
                      ),
                    ),
                    16.widthBox,
                    const Expanded(
                      child: SkeletonLoader(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 20,
                      ),
                    ),
                  ],
                ),
                20.heightBox,

                const SkeletonLoader(
                  width: double.infinity,
                  height: 120,
                  borderRadius: 24,
                ),
                20.heightBox,
                const SkeletonLoader(width: 150, height: 24),
                20.heightBox,
                // Transaction List Skeletons
                ...List.generate(
                  3,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const SkeletonLoader(
                      width: double.infinity,
                      height: 70,
                      borderRadius: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
