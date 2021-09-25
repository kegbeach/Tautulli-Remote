import 'package:flutter/material.dart';

import '../error/new_failure.dart';
import '../helpers/new_failure_helper.dart';
import 'new_card_base.dart';

class NewStatusCard extends StatelessWidget {
  final NewFailure? failure;
  final String? customStatus;

  const NewStatusCard({
    Key? key,
    this.failure,
    this.customStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String failureMessage = '';
    String failureSuggestion = '';

    if (failure != null) {
      failureMessage = NewFailureHelper.mapFailureToMessage(failure!);
      failureSuggestion = NewFailureHelper.mapFailureToSuggestion(failure!);
    }
    return NewCardBase(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (failure != null)
              Text(
                failureMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            if (failure != null) const SizedBox(height: 8),
            if (failure != null)
              Text(
                failureSuggestion,
                textAlign: TextAlign.center,
              ),
            if (customStatus != null)
              Text(
                customStatus!,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
