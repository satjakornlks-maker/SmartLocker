import 'package:flutter/material.dart';

class HoverMenuCard extends StatefulWidget {
  final String titleTh;
  final String? titleEn;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double aspectRatio;
  final Color hoverColor;

  const HoverMenuCard({
    super.key,
    required this.titleTh,
    this.titleEn,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.aspectRatio = 1.4,
    this.hoverColor = const Color(0xFFF9A825),
  });

  @override
  State<HoverMenuCard> createState() => _HoverMenuCardState();
}

class _HoverMenuCardState extends State<HoverMenuCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered ? widget.hoverColor : Colors.grey.shade300,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.1 : 0.05),
                blurRadius: _isHovered ? 15 : 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon at the top
                    Align(
                      alignment: Alignment.topRight,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isHovered
                              ? widget.hoverColor.withValues(alpha: 0.2)
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          size: 32,
                          color: _isHovered ? widget.hoverColor : Colors.grey.shade700,
                        ),
                      ),
                    ),

                    // Text at the bottom
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: _isHovered ? widget.hoverColor : Colors.black87,
                            ),
                            child: Text(widget.titleTh),
                          ),
                          if (widget.titleEn != null && widget.titleEn!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: TextStyle(
                                fontSize: 14,
                                color: _isHovered ? widget.hoverColor : Colors.grey.shade600,
                              ),
                              child: Text(widget.titleEn!),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}