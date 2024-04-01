
    //import 'package:flutter/material.dart';
    //import 'package:table_calendar/table_calendar.dart';

    //import 'utils.dart';


    /*


    class TableBasicsExample extends StatefulWidget {
      @override
      _TableBasicsExampleState createState() => _TableBasicsExampleState();
    }

    class _TableBasicsExampleState extends State<TableBasicsExample> {
      CalendarFormat _calendarFormat = CalendarFormat.month;
      DateTime _focusedDay = DateTime.now();
      DateTime? _selectedDay;

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('TableCalendar - Basics'),
          ),
          body: TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
          ),
        );
      }
    }

    */
/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:timezone/timezone.dart' as tz;

class TableBasicsExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}







class _MyHomePageState extends State<MyHomePage> {
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  bool _dateRangeSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rental Calendar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Date Range Selection Button
            ElevatedButton(
              onPressed: () async {
                DateTimeRange? pickedRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );

                if (pickedRange != null) {
                  setState(() {
                    _selectedDateRange = pickedRange;
                    _dateRangeSelected = true;
                  });
                }
              },
              child: Text('Select Date Range'),
            ),

            // Section 2: Edit Date Range Button
            ElevatedButton(
              onPressed: () {
                // Trigger the edit date range action
                _editDateRange();
              },
              child: Text('Edit Date Range'),
            ),

            // Section 3: Time Selection (Displayed after Date Range Selection)
            if (_dateRangeSelected)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Select Time Range:'),

                    // Section 3a: Button to select start time
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? startTime = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );

                        if (startTime != null) {
                          setState(() {
                            _startTime = startTime;
                          });
                        }
                      },
                      child: Text('Select Start Time'),
                    ),

                    // Section 3b: Button to select end time
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? endTime = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );

                        if (endTime != null) {
                          setState(() {
                            _endTime = endTime;
                          });
                        }
                      },
                      child: Text('Select End Time'),
                    ),
                  ],
                ),
              ),

            // Section 4: Display Selected Date and Time Range
            if (_dateRangeSelected)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Selected Range: '
                  '${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateRange.start.toLocal())} - '
                  '${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateRange.end.toLocal())}',
                  style: TextStyle(fontSize: 16),
                ),
              ),

            // Section 5: Display UTC Time Range
            if (_dateRangeSelected)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'UTC Range: '
                  '${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateRange.start.toUtc())} - '
                  '${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateRange.end.toUtc())}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _editDateRange() async {
    DateTimeRange? newDateRange = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Date Range'),
          content: DateRangePicker(
            initialDateRange: _selectedDateRange,
            onDateRangeChanged: (newDateRange) {
              // No need to setState here; it's handled by the DateRangePicker widget
            },
          ),
        );
      },
    );

    if (newDateRange != null) {
      setState(() {
        _selectedDateRange = newDateRange;
      });
    }
  }
}

class DateRangePicker extends StatefulWidget {
  final DateTimeRange initialDateRange;
  final Function(DateTimeRange) onDateRangeChanged;

  DateRangePicker({required this.initialDateRange, required this.onDateRangeChanged});

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTimeRange _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () async {
            DateTimeRange? pickedRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime.now().subtract(Duration(days: 365)),
              lastDate: DateTime.now().add(Duration(days: 365)),
              initialDateRange: _selectedDateRange,
            );

            if (pickedRange != null) {
              setState(() {
                _selectedDateRange = pickedRange;
              });

              // Pass the updated date range back to the main screen
              widget.onDateRangeChanged(_selectedDateRange);
            }
          },
          child: Text('Select Date Range'),
        ),
      ],
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';


class RentalItem {
  final String id;
  final String title;
  final String description;
  final double rentalPrice;
  final String location;
  final String condition;
  final String category;
  final List<String> images;
  List<String> availableDates;
  final List<RentalTransaction> rentalTransactions;

  RentalItem({
    required this.id,
    required this.title,
    required this.description,
    required this.rentalPrice,
    required this.location,
    required this.condition,
    required this.category,
    required this.images,
    required this.availableDates,
    required this.rentalTransactions,
  });

  void updateAvailableDates(List<String> newDates) {
    availableDates = newDates;
  }
}

class RentalTransaction {
  final String renterName;
  final String renterContact;
  final String rentalStartDate;
  final String rentalEndDate;
  final double totalPrice;

  RentalTransaction({
    required this.renterName,
    required this.renterContact,
    required this.rentalStartDate,
    required this.rentalEndDate,
    required this.totalPrice,
  });
}

class RentalItemDetailsPage extends StatefulWidget {
  final RentalItem rentalItem;

  RentalItemDetailsPage({required this.rentalItem});

  @override
  _RentalItemDetailsPageState createState() => _RentalItemDetailsPageState();
}

class _RentalItemDetailsPageState extends State<RentalItemDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rentalItem.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildRentalItemDetails(widget.rentalItem),
            _buildCalendar(widget.rentalItem.availableDates),
            ElevatedButton(
              onPressed: () => _selectDateRange(context),
              child: Text("Select Date Range"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentalItemDetails(RentalItem item) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailText('Description:', item.description),
          _buildDetailText('Price:', '\$${item.rentalPrice.toStringAsFixed(2)}'),
          _buildDetailText('Location:', item.location),
          _buildDetailText('Condition:', item.condition),
          _buildDetailText('Category:', item.category),
        ],
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildCalendar(List<String> availableDates) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCalendar(
        view: CalendarView.month,
        dataSource: RentalRangeDataSource(availableDates),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Date Range"),
          content: Container(
            height: 350,
            width: double.maxFinite,
            child: SfDateRangePicker(
              onSelectionChanged: _onDateRangeSelected,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                DateTime.now(),
                DateTime.now().add(Duration(days: 7)),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void _onDateRangeSelected(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final PickerDateRange range = args.value;
      final DateTime startDate = range.startDate!;
      final DateTime endDate = range.endDate ?? startDate;
      List<String> formattedDates = [
        DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate)
      ];
      setState(() {
        widget.rentalItem.updateAvailableDates(formattedDates);
      });
    }
  }
}

class RentalRangeDataSource extends CalendarDataSource {
  RentalRangeDataSource(List<String> availableDates) {
    appointments = availableDates.map((date) {
      final DateTime startDate = DateTime.parse(date);
      final DateTime endDate = startDate.add(Duration(days: 1));
      return Appointment(
        startTime: startDate,
        endTime: endDate,
        subject: 'Available',
        color: Colors.green,
      );
    }).toList();
  }
}