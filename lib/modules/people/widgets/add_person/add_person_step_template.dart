import 'package:flutter/material.dart';

class AddPersonStepTemplate extends StatefulWidget {
  final Widget? storyContent;
  final String title;
  final String description;
  final Widget child;
  final Widget sideContent;

  const AddPersonStepTemplate({
    super.key,
    this.storyContent,
    required this.title,
    required this.description,
    required this.child,
    required this.sideContent,
  });

  @override
  State<AddPersonStepTemplate> createState() => _AddPersonStepTemplateState();
}

class _AddPersonStepTemplateState extends State<AddPersonStepTemplate> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 1100;

        return Scrollbar(
          controller: _scrollController,
          thumbVisibility: isCompact,
          trackVisibility: isCompact,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1450),
                child: isCompact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.storyContent != null) ...[
                            widget.storyContent!,
                            const SizedBox(height: 32),
                          ],

                          _buildMainContent(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.storyContent != null) ...[
                            SizedBox(width: 340, child: widget.storyContent!),
                            const SizedBox(width: 32),
                          ],

                          Expanded(child: _buildMainContent()),

                          const SizedBox(width: 32),

                          SizedBox(width: 280, child: widget.sideContent),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2F3A4A),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          widget.description,
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            color: Color(0xFF6B7280),
          ),
        ),

        const SizedBox(height: 32),

        widget.child,
      ],
    );
  }
}
