// Based on flutter/packages/flutter/lib/src/material/list_tile.dart
//
// Copyright 2014 The Flutter Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

part of 'yaru_toggle_button.dart';

enum _YaruToggleButtonSlot { leading, title, subtitle }

class _YaruToggleButtonLayout extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_YaruToggleButtonSlot> {
  const _YaruToggleButtonLayout({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.textDirection,
  });

  final Widget leading;
  final Widget title;
  final Widget? subtitle;
  final double horizontalSpacing;
  final double verticalSpacing;
  final TextDirection textDirection;

  @override
  Iterable<_YaruToggleButtonSlot> get slots => _YaruToggleButtonSlot.values;

  @override
  Widget? childForSlot(_YaruToggleButtonSlot slot) {
    switch (slot) {
      case _YaruToggleButtonSlot.leading:
        return leading;
      case _YaruToggleButtonSlot.title:
        return title;
      case _YaruToggleButtonSlot.subtitle:
        return subtitle;
    }
  }

  @override
  _YaruRenderToggleButton createRenderObject(BuildContext context) {
    return _YaruRenderToggleButton(
      horizontalSpacing: horizontalSpacing,
      verticalSpacing: verticalSpacing,
      textDirection: textDirection,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _YaruRenderToggleButton renderObject,
  ) {
    renderObject.textDirection = textDirection;
  }
}

class _YaruRenderToggleButton extends RenderBox
    with SlottedContainerRenderObjectMixin<_YaruToggleButtonSlot> {
  _YaruRenderToggleButton({
    required double horizontalSpacing,
    required double verticalSpacing,
    required TextDirection textDirection,
  })  : _horizontalSpacing = horizontalSpacing,
        _verticalSpacing = verticalSpacing,
        _textDirection = textDirection;

  RenderBox? get leading => childForSlot(_YaruToggleButtonSlot.leading);
  RenderBox? get title => childForSlot(_YaruToggleButtonSlot.title);
  RenderBox? get subtitle => childForSlot(_YaruToggleButtonSlot.subtitle);

  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (leading != null) leading!,
      if (title != null) title!,
      if (subtitle != null) subtitle!
    ];
  }

  double get horizontalSpacing => _horizontalSpacing;
  double _horizontalSpacing;
  set horizontalSpacing(double value) {
    if (_horizontalSpacing == value) return;
    _horizontalSpacing = value;
    markNeedsLayout();
  }

  double get verticalSpacing => _verticalSpacing;
  double _verticalSpacing;
  set verticalSpacing(double value) {
    if (_verticalSpacing == value) return;
    _verticalSpacing = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  bool get sizedByParent => false;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0 : box.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _minWidth(leading, height) +
        horizontalSpacing +
        math.max(_minWidth(title, height), _minWidth(subtitle, height));
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _maxWidth(leading, height) +
        horizontalSpacing +
        math.max(_maxWidth(title, height), _maxWidth(subtitle, height));
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final subtitleHeight = subtitle != null
        ? subtitle!.getMinIntrinsicHeight(width) + verticalSpacing
        : 0;
    return title!.getMinIntrinsicHeight(width) + subtitleHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    final parentData = title!.parentData! as BoxParentData;
    return parentData.offset.dy + title!.getDistanceToActualBaseline(baseline)!;
  }

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) return Size.zero;
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox box, Offset offset) {
    final parentData = box.parentData! as BoxParentData;
    parentData.offset = offset;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => Size.zero;

  @override
  void performLayout() {
    final loosened = constraints.loosen();
    final availableWidth = loosened.maxWidth;

    final leadingSize = _layoutBox(leading, loosened);
    assert(
      availableWidth != leadingSize.width || availableWidth == 0,
      'ToggleButton.leading widget consumes entire button width.',
    );

    final titleX = leadingSize.width + horizontalSpacing;
    final textConstraints = constraints
        .copyWith(maxWidth: constraints.maxWidth - titleX)
        .normalize();
    final titleSize = _layoutBox(title, textConstraints);
    final subtitleSize = _layoutBox(subtitle, textConstraints);

    final leadingY = math.max(0.0, (titleSize.height - leadingSize.height) / 2);
    final titleY = math.max(0.0, (leadingSize.height - titleSize.height) / 2);
    final subtitleY = titleY + titleSize.height + verticalSpacing;

    final buttonWidth = leadingSize.width +
        horizontalSpacing +
        math.max(titleSize.width, subtitleSize.width);

    final buttonHeight = math.max(
      leadingSize.height,
      subtitle != null
          ? subtitleY + subtitleSize.height
          : titleY + titleSize.height,
    );

    switch (textDirection) {
      case TextDirection.rtl:
        if (leading != null) {
          _positionBox(
            leading!,
            Offset(buttonWidth - leadingSize.width, leadingY),
          );
        }
        _positionBox(title!, Offset(0, titleY));
        if (subtitle != null) {
          _positionBox(subtitle!, Offset(0, subtitleY));
        }
        break;
      case TextDirection.ltr:
        if (leading != null) {
          _positionBox(leading!, Offset(0, leadingY));
        }
        _positionBox(title!, Offset(titleX, titleY));
        if (subtitle != null) {
          _positionBox(subtitle!, Offset(titleX, subtitleY));
        }
        break;
    }

    size = constraints.constrain(Size(buttonWidth, buttonHeight));
    assert(size.width == constraints.constrainWidth(buttonWidth));
    assert(size.height == constraints.constrainHeight(buttonHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        final parentData = child.parentData! as BoxParentData;
        context.paintChild(child, parentData.offset + offset);
      }
    }

    doPaint(leading);
    doPaint(title);
    doPaint(subtitle);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in children) {
      final parentData = child.parentData! as BoxParentData;
      final isHit = result.addWithPaintOffset(
        offset: parentData.offset,
        position: position,
        hitTest: (result, transformed) {
          assert(transformed == position - parentData.offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) return true;
    }
    return false;
  }
}
