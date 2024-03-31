import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:saasify/screens/widgets/label_and_textfield_widget.dart'; // Ensure you have intl package in your pubspec.yaml

class CustomDatePickerWidget extends StatefulWidget {
  final String? label;
  final TextEditingController dateController;

  const CustomDatePickerWidget(
      {super.key, this.label, required this.dateController});

  @override
  CustomDatePickerWidgetState createState() => CustomDatePickerWidgetState();
}

class CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelAndTextFieldWidget(
          readOnly: true,
          label: widget.label,
          textFieldController: widget.dateController,
          prefixIcon: const Icon(Icons.calendar_month),
          hintText: "DD/MM/YYYY",
          onTap: () => _showDatePicker(context),
        ), // Use a specific value if app_spacing.dart is not available
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoButton(
                    child: const Text('OK'),
                    onPressed: () {
                      String formattedDate =
                          DateFormat('dd/MM/yyyy').format(selectedDate);
                      widget.dateController.text = formattedDate;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: selectedDate,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
