import 'package:flutter/material.dart';

class SelectionCard extends StatelessWidget {
  // Parameters should be in the constructor, not in build()
  final Widget title;
  final IconData icon;
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Builder(
          builder: (context) {
            final isHovered = ValueNotifier<bool>(false);

            return ValueListenableBuilder<bool>(
              valueListenable: isHovered,
              builder: (context, hovered, child) {
                return MouseRegion(
                  onEnter: (_) => isHovered.value = true,
                  onExit: (_) => isHovered.value = false,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(100),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: hovered
                            ? Colors.yellow.shade700
                            : Colors.grey.shade300,
                        width: hovered ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: hovered ? 0.1 : 0.05,
                          ),
                          blurRadius: hovered ? 15 : 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: hovered
                                ? Colors.yellow.shade100
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 40,
                            color: hovered
                                ? Colors.yellow.shade700
                                : Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Title
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: hovered
                                ? Colors.yellow.shade700
                                : Colors.black87,
                          ),
                          child: title,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}