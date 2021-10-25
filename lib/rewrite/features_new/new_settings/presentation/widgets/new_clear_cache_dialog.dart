import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../new_cache/presentation/bloc/new_cache_bloc.dart';

class NewClearCacheDialog extends StatelessWidget {
  const NewClearCacheDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Clear Image Cache'),
      content: const Text('Are you sure you want to clear the cache?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            context.read<NewCacheBloc>().add(NewCacheClear());
            Navigator.of(context).pop();
          },
          child: const Text('CLEAR'),
        ),
      ],
    );
  }
}
