import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay>? onSelectedTime;

  const TimePicker({
    super.key,
    required this.labelText,
    required this.selectedTime,
    this.onSelectedTime,
  });

  Future<void> selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime?.call(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleLarge!;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () => selectTime(context),
          ),
        ),
      ],
    );
  }
}

String formatTime(TimeOfDay time, BuildContext context) {
  final now = DateTime.now();
  final formattedTime = DateFormat('hh:mm a')
      .format(DateTime(now.year, now.month, now.day, time.hour, time.minute));
  return formattedTime;
}

TimeOfDay toTimeFromFormatTime(String time) {
  
  final formattedTime = DateFormat('hh:mm a')
      .parse(time);
  
  return TimeOfDay.fromDateTime(formattedTime);
}

class InputDropdown extends StatelessWidget {
  const InputDropdown({
    Key? key,
    this.labelText,
    required this.valueText,
    required this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String? labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
