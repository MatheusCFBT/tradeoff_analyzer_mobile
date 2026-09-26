import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradeoff_analyzer_mobile/features/shared/widgets/app_header.dart';

void main() {
  testWidgets('shows placeholder when no avatar provided', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppHeader(
            title: 'Test',
          ),
        ),
      ),
    );

    // Should display the person icon inside the CircleAvatar
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byKey(const Key('app_header_avatar')), findsOneWidget);
  });

  testWidgets('uses provided ImageProvider when given', (tester) async {
    // Create a 1x1 transparent pixel
    final bytes = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82
    ]);

    final provider = MemoryImage(bytes);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppHeader(
            title: 'Test',
            avatarImageProvider: provider,
          ),
        ),
      ),
    );

    // Verify CircleAvatar has backgroundImage set
    final avatar = tester.widget<CircleAvatar>(find.byKey(const Key('app_header_avatar')));
    expect(avatar.backgroundImage, isNotNull);
  });

  testWidgets('onAvatarTap is called when avatar tapped', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppHeader(
            title: 'TapTest',
            onAvatarTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('app_header_avatar_gesture')));
    await tester.pumpAndSettle();

    expect(tapped, isTrue);
  });

  testWidgets('shows leading when provided', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppHeader(
            title: 'LeadTest',
            leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
