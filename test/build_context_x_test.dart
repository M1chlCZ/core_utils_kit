import 'package:core_utils_kit/core_utils_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('afterBuild runs the callback after the current frame', (
    tester,
  ) async {
    final calls = <String>[];

    await tester.pumpWidget(
      Builder(
        builder: (context) {
          context.afterBuild(() => calls.add('afterBuild'));
          calls.add('build');
          return const SizedBox.shrink();
        },
      ),
    );

    expect(calls, ['build']);

    await tester.pump(Duration.zero);

    expect(calls, ['build', 'afterBuild']);
  });
}
