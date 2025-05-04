import 'package:flix_id/presentation/providers/ui_loading_request/ui_loading_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingButton extends ConsumerWidget {
  final Widget child;
  final Future<void> Function() onPressed;
  final ButtonStyle? style;

  const LoadingButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(uiLoadingRequestProvider);
    final loadingNotifier = ref.read(uiLoadingRequestProvider.notifier);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                loadingNotifier.startLoading();
                await onPressed();
                loadingNotifier.dismissLoading();
              },
        style: style,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : child,
      ),
    );
  }
}
