import 'package:f_managment_stream_accounts/forms/components/custom_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onSelectedDate;

  const DatePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    this.onSelectedDate,
  });

  Future<void> selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate?.call(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleLarge!;
    return Expanded(
      flex: 5,
      child: InputDropdown(
        labelText: labelText,
        valueText: Format.dateShort(selectedDate),
        valueStyle: valueStyle,
        onPressed: () => selectDate(context),
      ),
    );
  }
}

class Format {
  static String dateShort(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  static DateTime dateShortString(String dateTime) {
    return DateFormat('dd-MM-yyyy').parse(dateTime);
  }

  @Deprecated('no usar solo con')
  static DateTime fromDateShortToISO(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }
  
  static String toDateMonthLetter(DateTime dateTime) {
    return DateFormat.yMMMMd().format(dateTime);
  }

}
