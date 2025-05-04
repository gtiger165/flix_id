import 'package:flix_id/presentation/providers/ui_loading_request/ui_loading_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingWrapper extends ConsumerWidget {
  final Widget child;

  const LoadingWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(uiLoadingRequestProvider);

    return Stack(
      children: [
        child,
        if (isLoading) ...[
          const ModalBarrier(
            dismissible: false,
            color: Colors.black12,
          ),
          const Center(
            child: CircularProgressIndicator(),
          )
        ],
      ],
    );
  }
}
