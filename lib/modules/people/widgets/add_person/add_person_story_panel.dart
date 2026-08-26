import 'package:flutter/material.dart';

class AddPersonStoryPanel extends StatelessWidget {
  final String title;
  final String highlightedText;
  final String description;
  final IconData icon;

  const AddPersonStoryPanel({
    super.key,
    required this.title,
    required this.highlightedText,
    required this.description,
    this.icon = Icons.person_add_alt_1_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F7FF), Color(0xFFF0EDFF), Color(0xFFE5DFFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0DBF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 28,
            offset: const Offset(10, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Large decorative circle.
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6D4CC6).withValues(alpha: 0.05),
                ),
              ),
            ),

            // Large lower background shape.
            Positioned(
              bottom: -160,
              right: -130,
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6D4CC6).withValues(alpha: 0.08),
                ),
              ),
            ),

            // Decorative dots.
            Positioned(top: 70, right: 40, child: _buildDots()),

            Padding(
              padding: const EdgeInsets.fromLTRB(40, 58, 40, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Color(0xFF2F3A4A),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    highlightedText,
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      color: Color(0xFF5B3FC4),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Color(0xFF5F6B7A),
                    ),
                  ),

                  const SizedBox(height: 48),

                  Center(child: _buildGraphic()),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return SizedBox(
      width: 70,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          20,
          (index) => Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF6D4CC6).withValues(alpha: 0.18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGraphic() {
    return SizedBox(
      height: 260,
      width: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Connection line - left.
          Positioned(
            left: 35,
            top: 145,
            child: Container(
              width: 85,
              height: 1,
              color: const Color(0xFF9D8AE8).withValues(alpha: 0.55),
            ),
          ),

          // Connection line - right.
          Positioned(
            right: 35,
            top: 145,
            child: Container(
              width: 85,
              height: 1,
              color: const Color(0xFF9D8AE8).withValues(alpha: 0.55),
            ),
          ),

          // Connection line - upper.
          Positioned(
            top: 70,
            child: Container(
              width: 1,
              height: 70,
              color: const Color(0xFF9D8AE8).withValues(alpha: 0.45),
            ),
          ),

          // Top group node.
          Positioned(
            top: 25,
            child: _buildNode(
              icon: Icons.groups_rounded,
              size: 68,
              iconSize: 30,
            ),
          ),

          // Left person node.
          Positioned(
            left: 5,
            bottom: 18,
            child: _buildNode(
              icon: Icons.person_rounded,
              size: 70,
              iconSize: 32,
            ),
          ),

          // Right person node.
          Positioned(
            right: 5,
            bottom: 18,
            child: _buildNode(
              icon: Icons.person_rounded,
              size: 70,
              iconSize: 32,
            ),
          ),

          // Main person/add node.
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6D4CC6), Color(0xFF4F36B5)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5B3FC4).withValues(alpha: 0.25),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 42),
          ),

          // Success/check node.
          Positioned(
            right: 28,
            top: 145,
            child: _buildNode(
              icon: Icons.check_rounded,
              size: 52,
              iconSize: 27,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode({
    required IconData icon,
    required double size,
    required double iconSize,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.92),
        border: Border.all(color: const Color(0xFFD8D0F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF5B3FC4), size: iconSize),
    );
  }
}
