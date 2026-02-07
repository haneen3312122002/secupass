import 'package:flutter/material.dart';

/// Controller to control selected index programmatically (optional).
class GroupButtonController {
  /// If you want to preselect an item, pass selectedIndex.
  /// If null, nothing is selected initially.
  int? selectedIndex;

  GroupButtonController({this.selectedIndex});
}

/// Styling options for GroupButton.
class GroupButtonOptions {
  final double spacing;
  final double runSpacing;
  final BorderRadius borderRadius;
  final double buttonHeight;
  final double buttonWidth;

  final Color selectedColor;
  final Color unselectedColor;

  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;

  final BorderSide? selectedBorderSide;
  final BorderSide? unselectedBorderSide;

  final EdgeInsetsGeometry padding;

  const GroupButtonOptions({
    this.spacing = 12,
    this.runSpacing = 10,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.buttonHeight = 40,
    this.buttonWidth = 90,
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedTextStyle,
    required this.unselectedTextStyle,
    this.selectedBorderSide,
    this.unselectedBorderSide,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });
}

/// A lightweight replacement for the "group_button" package.
/// Supports radio (single select) and multi select modes.
class GroupButton<T> extends StatefulWidget {
  final bool isRadio;
  final List<T> buttons;

  /// Called when a button is tapped.
  /// val: the button value
  /// index: index of tapped button
  /// isSelected: whether it's selected after the tap
  final void Function(T val, int index, bool isSelected) onSelected;

  final GroupButtonController? controller;
  final GroupButtonOptions options;

  const GroupButton({
    super.key,
    required this.isRadio,
    required this.buttons,
    required this.onSelected,
    this.controller,
    required this.options,
  });

  @override
  State<GroupButton<T>> createState() => _GroupButtonState<T>();
}

class _GroupButtonState<T> extends State<GroupButton<T>> {
  late final Set<int> _selectedIndexes;

  @override
  void initState() {
    super.initState();
    _selectedIndexes = <int>{};

    // preselect from controller (like your usage)
    final pre = widget.controller?.selectedIndex;
    if (pre != null && pre >= 0 && pre < widget.buttons.length) {
      _selectedIndexes.add(pre);
    }
  }

  @override
  void didUpdateWidget(covariant GroupButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If controller.selectedIndex changes, reflect it
    final newSelected = widget.controller?.selectedIndex;
    final oldSelected = oldWidget.controller?.selectedIndex;

    if (newSelected != oldSelected) {
      setState(() {
        _selectedIndexes.clear();
        if (newSelected != null &&
            newSelected >= 0 &&
            newSelected < widget.buttons.length) {
          _selectedIndexes.add(newSelected);
        }
      });
    }
  }

  void _toggle(int index) {
    final isCurrentlySelected = _selectedIndexes.contains(index);

    setState(() {
      if (widget.isRadio) {
        _selectedIndexes
          ..clear()
          ..add(index);
        widget.controller?.selectedIndex = index;
      } else {
        if (isCurrentlySelected) {
          _selectedIndexes.remove(index);
        } else {
          _selectedIndexes.add(index);
        }
      }
    });

    final isSelectedAfterTap = _selectedIndexes.contains(index);
    widget.onSelected(widget.buttons[index], index, isSelectedAfterTap);
  }

  @override
  Widget build(BuildContext context) {
    final opt = widget.options;

    return Wrap(
      spacing: opt.spacing,
      runSpacing: opt.runSpacing,
      children: List.generate(widget.buttons.length, (index) {
        final selected = _selectedIndexes.contains(index);

        final bgColor = selected ? opt.selectedColor : opt.unselectedColor;
        final textStyle =
            selected ? opt.selectedTextStyle : opt.unselectedTextStyle;

        final borderSide = selected
            ? (opt.selectedBorderSide ??
                BorderSide(color: Colors.transparent, width: 1))
            : (opt.unselectedBorderSide ??
                BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.4),
                    width: 1));

        return SizedBox(
          width: opt.buttonWidth,
          height: opt.buttonHeight,
          child: Material(
            color: bgColor,
            borderRadius: opt.borderRadius,
            child: InkWell(
              borderRadius: opt.borderRadius,
              onTap: () => _toggle(index),
              child: Container(
                padding: opt.padding,
                decoration: BoxDecoration(
                  borderRadius: opt.borderRadius,
                  border: Border.fromBorderSide(borderSide),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.buttons[index].toString(),
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
