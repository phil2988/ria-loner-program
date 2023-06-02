import 'package:flutter/material.dart';

class SelectDateWidget extends StatefulWidget {
  const SelectDateWidget({
    required this.onDateSelected,
    required this.label,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    super.key,
  });
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final Function(DateTime?)? onDateSelected;

  @override
  State<StatefulWidget> createState() => _SelectDateWidgetState();
}

class _SelectDateWidgetState extends State<SelectDateWidget> {
  DateTime? selectedDate;

  DateTime? firstDate;
  DateTime? lastDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (selectedDate == null) {
      return ElevatedButton(
          onPressed: () => showDatePicker(
                context: context,
                initialDate: widget.initialDate ?? DateTime.now(),
                firstDate: widget.firstDate ??
                    DateTime.now().subtract(const Duration(days: 100)),
                lastDate: widget.lastDate ??
                    DateTime.now().add(const Duration(days: 100)),
              ).then((value) => {
                    value != null && widget.onDateSelected != null
                        ? {widget.onDateSelected!(value), selectedDate = value}
                        : null
                  }),
          child: Text("Select date",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )));
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          width: 1,
          color: theme.colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "${selectedDate!.day}/${selectedDate!.month}-${selectedDate!.year}"),
            IconButton(
                onPressed: () => setState(() {
                      if (widget.onDateSelected != null) {
                        widget.onDateSelected!(null);
                        selectedDate = null;
                      }
                    }),
                splashRadius: 1,
                icon: const Icon(Icons.clear))
          ],
        ),
      ),
    );
  }
}
