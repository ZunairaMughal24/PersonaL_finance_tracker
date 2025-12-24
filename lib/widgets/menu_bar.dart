import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finance_tracker/config/router.dart';

class PopUpMenu extends StatelessWidget {
  final Function(String) onItemSelected;

  const PopUpMenu({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: (value) => onItemSelected(value),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'Edit',
          child: Text('Edit'),
         
        ),
        PopupMenuItem(value: 'Delete', child: Text('Delete'),),
        PopupMenuItem(value: 'Detail', child: Text('Detail')),
      ],
    );
  }
}
