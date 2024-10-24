import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  final List<String> listofItems;
  const DropDownMenu({Key? key, required this.listofItems}) : super(key: key);

  @override
  State<DropDownMenu> createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue.isNotEmpty ? dropdownValue : null,
      icon: const Icon(Icons.arrow_downward),
      onChanged: (newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: [
        const DropdownMenuItem<String>(
          value: '', // Empty value to indicate initial state
          child: Text('Select Type'),
        ),
        ...widget.listofItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }),
      ],
    );
  }
}
