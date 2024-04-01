import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncCalendar extends StatefulWidget {
  @override
  _SyncCalendarState createState() => _SyncCalendarState();
}

class _SyncCalendarState extends State<SyncCalendar> {
  PickerDateRange? _selectedRange;

  List<int> unavailableHours = [9, 10, 15, 16]; // Example: 9:00, 10:00, 15:00, 16:00 are unavailable

  List<PickerDateRange> _unselectableRanges = [
    PickerDateRange(
      DateTime(2024, 2, 5),
      DateTime(2024, 2, 10),
    ),
    PickerDateRange(
      DateTime(2024, 2, 15),
      DateTime(2024, 2, 20),
    ),
    PickerDateRange(
      DateTime(2024, 1, 12),
      DateTime(2024, 1, 20),
    ),
    // Add more ranges as needed
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedRange();
  }

  bool _isSelectable(DateTime date) {
    for (PickerDateRange range in _unselectableRanges) {
      DateTime? start = range.startDate;
      DateTime? end = range.endDate;
      if (start != null && end != null) {
        if (date.isAfter(start.subtract(const Duration(days: 1))) &&
            date.isBefore(end.add(const Duration(days: 1)))) {
          return false;
        }
      }
    }
    return true;
  }

  PickerDateRange _adjustRangeToAvoidBlockout(PickerDateRange selectedRange) {
    DateTime startDate = selectedRange.startDate ?? DateTime.now();
    DateTime endDate = selectedRange.endDate ?? DateTime.now();

    for (PickerDateRange blockoutRange in _unselectableRanges) {
      DateTime? blockoutStart = blockoutRange.startDate;
      DateTime? blockoutEnd = blockoutRange.endDate;

      if (blockoutStart == null || blockoutEnd == null) continue;

      if (startDate.isBefore(blockoutStart) && (endDate.isAfter(blockoutStart) || endDate.isAtSameMomentAs(blockoutStart))) {
        endDate = blockoutStart.subtract(const Duration(days: 1));
      }

      if (startDate.isAfter(blockoutStart) && startDate.isBefore(blockoutEnd)) {
        startDate = blockoutEnd.add(const Duration(days: 1));
        if (startDate.isAfter(endDate)) {
          return PickerDateRange(null, null);  // Invalidate the selection
        }
      }
    }

    return PickerDateRange(startDate, endDate);
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      PickerDateRange selectedRange = args.value as PickerDateRange;
      setState(() {
        _selectedRange = _adjustRangeToAvoidBlockout(selectedRange);
      });
    }
  }


/*
Future<void> _showTimePickerDialog() async {
  int dropOffHour = 12; // Initial value for drop-off hour
  int pickUpHour = 12;  // Initial value for pick-up hour

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Select Drop-off Time", style: TextStyle(fontSize: 18)),
                Slider(
                  min: 0,
                  max: 23,
                  divisions: 23,
                  value: dropOffHour.toDouble(),
                  label: "$dropOffHour:00",
                  onChanged: unavailableHours.contains(dropOffHour)
                      ? null
                      : (double value) {
                          setState(() => dropOffHour = value.toInt());
                        },
                ),
                SizedBox(height: 20),
                Text("Select Pick-up Time", style: TextStyle(fontSize: 18)),
                Slider(
                  min: 0,
                  max: 23,
                  divisions: 23,
                  value: pickUpHour.toDouble(),
                  label: "$pickUpHour:00",
                  onChanged: unavailableHours.contains(pickUpHour)
                      ? null
                      : (double value) {
                          setState(() => pickUpHour = value.toInt());
                        },
                ),
                ElevatedButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text('Drop off at: $dropOffHour:00, Pick up at: $pickUpHour:00'),
                      duration: Duration(seconds: 5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

*/

Future<void> _showTimePickerDialog() async {
  int dropOffHour = 12; // Initial value for drop-off hour
  int pickUpHour = 12;  // Initial value for pick-up hour

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Select Drop-off Time", style: TextStyle(fontSize: 18)),
                _buildHourPicker(
                  selectedHour: dropOffHour,
                  onHourChanged: (int hour) => setState(() => dropOffHour = hour),
                ),
                SizedBox(height: 20),
                Text("Select Pick-up Time", style: TextStyle(fontSize: 18)),
                _buildHourPicker(
                  selectedHour: pickUpHour,
                  onHourChanged: (int hour) => setState(() => pickUpHour = hour),
                ),
                ElevatedButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text('Drop off at: $dropOffHour:00, Pick up at: $pickUpHour:00'),
                      duration: Duration(seconds: 5),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                ),
              ],
            ),
          );
        },
      );
    },
  );
}




Widget _buildHourPicker({required int selectedHour, required ValueChanged<int> onHourChanged}) {
  return SizedBox(
    height: 150, // Adjust the height as needed
    child: ListWheelScrollView.useDelegate(
      itemExtent: 40, // Height of each item
      perspective: 0.01, // Adjust for the 3D effect
      diameterRatio: 2.5, // Diameter of the cylinder
      onSelectedItemChanged: (index) {
        if (!unavailableHours.contains(index)) {
          onHourChanged(index);
        }
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 24,
        builder: (BuildContext context, int index) {
          final bool isUnavailable = unavailableHours.contains(index);
          return Center(
            child: Text(
              '$index:00',
              style: TextStyle(
                fontSize: 16,
                color: isUnavailable ? Colors.grey : Colors.black,
                fontWeight: selectedHour == index ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    ),
  );
}









  Future<void> _saveSelectedRange() async {
    final prefs = await SharedPreferences.getInstance();
    final start = _selectedRange?.startDate?.toIso8601String() ?? '';
    final end = _selectedRange?.endDate?.toIso8601String() ?? '';
    await prefs.setString('selectedDateRange', '$start|$end');
  }

  Future<void> _loadSelectedRange() async {
    final prefs = await SharedPreferences.getInstance();
    final rangeString = prefs.getString('selectedDateRange');
    if (rangeString != null && rangeString.isNotEmpty) {
      final dates = rangeString.split('|');
      final start = DateTime.parse(dates[0]);
      final end = dates[1].isNotEmpty ? DateTime.parse(dates[1]) : null;
      setState(() {
        _selectedRange = PickerDateRange(start, end);
      });
    }
  }


/*
Widget _cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
  // Check if the date is the start or end of the selected range
  bool isStartOfRange = _selectedRange != null && details.date.isAtSameMomentAs(_selectedRange!.startDate!);
  bool isEndOfRange = _selectedRange != null && details.date.isAtSameMomentAs(_selectedRange!.endDate ?? _selectedRange!.startDate!);
  bool isWithinRange = _selectedRange != null && details.date.isAfter(_selectedRange!.startDate!) &&
                       details.date.isBefore((_selectedRange!.endDate ?? _selectedRange!.startDate!).add(const Duration(days: 1)));

  // Check if the date is within the blackout range
  bool isBlackoutDate = _unselectableRanges.any((range) =>
      details.date.isAfter(range.startDate!.subtract(const Duration(days: 1))) &&
      details.date.isBefore(range.endDate!.add(const Duration(days: 1))));

  BoxDecoration decoration = BoxDecoration();
  
  // Apply different styles based on the date's status
  if (isBlackoutDate) {
    decoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [Color.fromARGB(92, 164, 152, 111), Color.fromARGB(75, 136, 130, 94)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  } else if (isStartOfRange || isEndOfRange) {
    decoration = BoxDecoration(
      color: Colors.yellow, // Color for start/end dates of the selected range
      shape: BoxShape.circle,
    );
  } else if (isWithinRange) {
    decoration = BoxDecoration(
      color: Colors.green.withOpacity(0.5), // Color for dates within the selected range
      shape: BoxShape.rectangle,
    );
  } // No 'else' needed here as the default decoration is already set to BoxDecoration()

  return Container(
    decoration: decoration,
    child: Center(
      child: Text(
        '${details.date.day}',
        style: TextStyle(color: isBlackoutDate || isWithinRange || isStartOfRange || isEndOfRange ? Colors.white : Colors.black),
      ),
    ),
  );



}



*/
Widget _cellBuilder(BuildContext context, DateRangePickerCellDetails details) {
  bool isStartOfRange = _selectedRange != null && details.date.isAtSameMomentAs(_selectedRange!.startDate!);
  bool isEndOfRange = _selectedRange != null && details.date.isAtSameMomentAs(_selectedRange!.endDate ?? _selectedRange!.startDate!);
  bool isWithinRange = _selectedRange != null && details.date.isAfter(_selectedRange!.startDate!) &&
                       details.date.isBefore((_selectedRange!.endDate ?? _selectedRange!.startDate!).add(const Duration(days: 1)));

  bool isBlackoutDate = _unselectableRanges.any((range) =>
      details.date.isAfter(range.startDate!.subtract(const Duration(days: 1))) &&
      details.date.isBefore(range.endDate!.add(const Duration(days: 1))));

  return Container(
    margin: isWithinRange || isStartOfRange ? const EdgeInsets.only(top: 15, bottom: 15): isEndOfRange ? const EdgeInsets.only(top: 15, bottom: 15, right: 10) : const EdgeInsets.all(4), // Optional: to provide external spacing
    decoration: BoxDecoration(
      color: isWithinRange || isStartOfRange ? Color.fromARGB(255, 255, 243, 9).withOpacity(0.4) : Colors.transparent,
      borderRadius: isBlackoutDate ? BorderRadius.circular(10): isStartOfRange ? BorderRadius.circular(10): isEndOfRange ? BorderRadius.circular(10): BorderRadius.circular(0),
      border: isBlackoutDate ? Border.all(color: Colors.red, width: 2) : null,  // Example for blackout dates
      gradient: isBlackoutDate ? LinearGradient(
        colors: [Color.fromARGB(92, 164, 152, 111), Color.fromARGB(75, 136, 130, 94)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ) : null,
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Text(
          '${details.date.day}',
          style: TextStyle(color: isWithinRange || isStartOfRange || isEndOfRange || isBlackoutDate ? Colors.white : Colors.black),
        ),
        if (isStartOfRange || isEndOfRange)
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow, // Style for start/end of the range
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    ),
  );
}



  void _showSnackbarWithSelectedRange() {
    if (_selectedRange != null) {
      final startDate = DateFormat('yyyy-MM-dd').format(_selectedRange!.startDate!);
      final endDate = _selectedRange!.endDate != null ? DateFormat('yyyy-MM-dd').format(_selectedRange!.endDate!) : 'N/A';
      final snackBar = SnackBar(
        content: Text('Selected range: $startDate to $endDate'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      _showTimePickerDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DatePicker Demo'),
        backgroundColor: Color.fromARGB(255, 190, 173, 18),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,  // Set the width of the calendar
              height: 400, // Set the height of the calendar
              padding: EdgeInsets.all(8), // Optional: to provide internal spacing
              decoration: BoxDecoration(
                color: Colors.grey.shade800, // Change the background color
                borderRadius: BorderRadius.circular(20), // Optional: for rounded corners
              ),
              child: SfDateRangePicker(
                selectionShape: DateRangePickerSelectionShape.circle,
                selectionRadius: 10,
                
                startRangeSelectionColor: Colors.yellow.withOpacity(0),
                endRangeSelectionColor: Colors.yellow.withOpacity(0),
                //selectionColor: Color.fromARGB(255, 239, 228, 12), // Color of the selected range edges
                rangeSelectionColor: Colors.yellow.withOpacity(0), // Color of the range between start and end dates
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: _selectedRange,
                selectableDayPredicate: _isSelectable,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  specialDates: _unselectableRanges.expand((range) {
                    return _getDatesInRange(range.startDate, range.endDate);
                  }).toList(),
                ),
                monthCellStyle: _getMonthCellStyle(),
                cellBuilder: _cellBuilder,
              ),
            ),
            ElevatedButton(
              onPressed: _showSnackbarWithSelectedRange,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getDatesInRange(DateTime? start, DateTime? end) {
    final startDate = start ?? DateTime.now();
    final endDate = end ?? DateTime.now();
    final days = endDate.difference(startDate).inDays;
    return List.generate(days, (index) => DateTime(startDate.year, startDate.month, startDate.day + index));
  }

  DateRangePickerMonthCellStyle _getMonthCellStyle() {
    return DateRangePickerMonthCellStyle();
  }
}