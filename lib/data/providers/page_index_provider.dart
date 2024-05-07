import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageIndexProvider = NotifierProvider<PageIndexNotifier, int>(PageIndexNotifier.new);

class PageIndexNotifier extends Notifier<int> {
  @override
  int build() {
    return 1;
  }

  void updateValue(int value) {
    state = value;
  }
}
