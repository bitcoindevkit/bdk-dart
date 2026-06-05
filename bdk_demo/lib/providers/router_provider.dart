import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/router/app_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = createRouter(ref.read);
  ref.onDispose(router.dispose);
  return router;
});
