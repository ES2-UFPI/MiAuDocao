import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final String hint;
  final String selectedItem;
  final List<String> itemsList;
  final Function(String) onSelected;

  CustomDropdownButton({
    @required this.hint,
    @required this.selectedItem,
    @required this.itemsList,
    @required this.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade200
      ),
      padding: EdgeInsets.only(right: 6),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            hint: Text(hint),
            value: selectedItem,
            items: itemsList.map<DropdownMenuItem<String>> ((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
            onChanged: onSelected,
          ),
        ),
      ),
    );
  }
}