import 'package:flutter/material.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({
    super.key,
    required this.title,
    required this.itemsCount,
    required this.color,
  });

  final String title;
  final int itemsCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            spreadRadius: 3,
            offset: const Offset(0, 2),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              if (itemsCount != 1)
                Text(
                  '$itemsCount items',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              if (itemsCount == 1)
                Text(
                  '$itemsCount item',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
            ],
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              color: color,
            ),
          )
        ],
      ),
    );
  }
}
