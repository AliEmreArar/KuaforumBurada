import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/hairdresser.dart';

class SalonCard extends StatelessWidget {
  final Hairdresser salon;
  final VoidCallback onTap;

  const SalonCard({
    super.key,
    required this.salon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            // Image Grid
            SizedBox(
              height: 200, // Adjust height as needed to match aspect ratio
              child: Row(
                children: [
                  // Big Image (Left)
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 1), // Gap
                      child: _buildImage(salon.imageUrl),
                    ),
                  ),
                  // Small Images (Right)
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 1), // Gap
                            child: _buildImage(salon.imageUrl),
                          ),
                        ),
                        Expanded(
                          child: _buildImage(salon.imageUrl),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          salon.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111618),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${salon.rating} (180+) • ~1.2 km • \$\$\$', // Mock data for reviews/dist/price
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF617C89),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                        Icons.favorite_border), // Or favorite if liked
                    color: const Color(0xFF111618),
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey.shade200,
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported),
      ),
    );
  }
}
