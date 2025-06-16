import 'package:flutter/material.dart';

class AddTodoButton extends StatelessWidget {
  final void Function() onTap;
  const AddTodoButton({
    super.key,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8),
        child: Icon(
          Icons.add_outlined,
          size: 30,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
