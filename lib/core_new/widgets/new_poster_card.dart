import 'package:flutter/material.dart';

import 'new_card_base.dart';
import 'new_poster_chooser.dart';

class NewPosterCard extends StatelessWidget {
  final dynamic itemModel;
  final Widget child;
  final Key? heroTag;

  const NewPosterCard({
    Key? key,
    required this.itemModel,
    required this.child,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewCardBase(
      backgroundImageUrl: itemModel.posterUrl,
      child: Row(
        children: [
          Hero(
            tag: heroTag ?? UniqueKey(),
            child: NewPosterChooser(itemModel: itemModel),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
