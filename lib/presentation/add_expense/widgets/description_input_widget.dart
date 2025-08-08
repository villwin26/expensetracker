import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DescriptionInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onDescriptionChanged;
  final VoidCallback? onVoiceInput;

  const DescriptionInputWidget({
    super.key,
    required this.controller,
    required this.onDescriptionChanged,
    this.onVoiceInput,
  });

  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {
  final FocusNode _focusNode = FocusNode();
  final List<String> _suggestions = [
    'Lunch at restaurant',
    'Grocery shopping',
    'Gas station',
    'Coffee',
    'Uber ride',
    'Movie tickets',
    'Pharmacy',
    'Parking fee',
    'Internet bill',
    'Electricity bill',
  ];

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    final text = widget.controller.text.toLowerCase();
    setState(() {
      if (text.isEmpty) {
        _filteredSuggestions = _suggestions.take(5).toList();
      } else {
        _filteredSuggestions = _suggestions
            .where((suggestion) => suggestion.toLowerCase().contains(text))
            .take(5)
            .toList();
      }
    });
    widget.onDescriptionChanged(widget.controller.text);
  }

  void _selectSuggestion(String suggestion) {
    widget.controller.text = suggestion;
    widget.onDescriptionChanged(suggestion);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2.h),
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'What did you spend on?',
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 2,
                ),
              ),
              suffixIcon: widget.onVoiceInput != null
                  ? IconButton(
                      onPressed: widget.onVoiceInput,
                      icon: CustomIconWidget(
                        iconName: 'mic',
                        color: theme.colorScheme.primary,
                        size: 5.w,
                      ),
                      tooltip: 'Voice input',
                    )
                  : null,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
          ),
          if (_showSuggestions && _filteredSuggestions.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              constraints: BoxConstraints(maxHeight: 20.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filteredSuggestions.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                itemBuilder: (context, index) {
                  final suggestion = _filteredSuggestions[index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      suggestion,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    leading: CustomIconWidget(
                      iconName: 'history',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 4.w,
                    ),
                    onTap: () => _selectSuggestion(suggestion),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
