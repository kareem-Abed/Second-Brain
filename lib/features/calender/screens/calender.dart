import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../common/widgets/loaders/loaders.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CalendarViewController controller = Get.put(CalendarViewController());

    return Container(
      color: KColors.darkModeBackground,
      child: Column(
        children: [
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: KSizes.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calender',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: () => _showAddEventDialog(context, controller),
                  icon: const Icon(
                    IconsaxPlusLinear.add,
                    color: KColors.darkGrey,
                    size: KSizes.lg,
                  ),
                ),
              ],
            ),
          ),

          // View mode buttons
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: KSizes.md, vertical: KSizes.sm),
            decoration: BoxDecoration(
              color: KColors.darkModeSubCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildViewButton(controller, CalendarView.day, 'Day'),
                    _buildViewButton(controller, CalendarView.week, 'Week'),
                    _buildViewButton(controller, CalendarView.month, 'Month'),
                  ],
                )),
          ),

          // Calendar view
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: KColors.darkModeSubCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Obx(() => SfCalendar(
                      key: ValueKey(controller.currentView.value),
                      view: controller.currentView.value,
                      dataSource: EventDataSource(controller.events.value),
                      backgroundColor: KColors.darkModeSubCard,
                      headerStyle: const CalendarHeaderStyle(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: KColors.darkModeSubCard,
                      ),
                      viewHeaderStyle: const ViewHeaderStyle(
                        backgroundColor: KColors.darkModeSubCard,
                        dayTextStyle: TextStyle(color: Colors.white70),
                        dateTextStyle: TextStyle(color: Colors.white),
                      ),
                      monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        monthCellStyle: MonthCellStyle(
                          backgroundColor: KColors.darkModeSubCard,
                          textStyle: const TextStyle(color: Colors.white),
                          todayBackgroundColor:
                              KColors.primary.withOpacity(0.3),
                          todayTextStyle: const TextStyle(color: Colors.white),
                        ),
                      ),
                      timeSlotViewSettings: const TimeSlotViewSettings(
                        timeTextStyle: TextStyle(color: Colors.white70),
                      ),
                      onTap: (CalendarTapDetails details) {
                        if (details.targetElement ==
                            CalendarElement.appointment) {
                          controller
                              .showEventOptions(details.appointments!.first);
                        } else if (details.targetElement ==
                            CalendarElement.calendarCell) {
                          controller.showQuickAddEvent(details.date!);
                        }
                      },
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(
      CalendarViewController controller, CalendarView view, String title) {
    final isSelected = controller.currentView.value == view;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          print('Button tapped: $title');
          controller.changeView(view);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected ? KColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _showAddEventDialog(
      BuildContext context, CalendarViewController controller) {
    Get.dialog(
      AddEventDialog(controller: controller),
      barrierDismissible: true,
    );
  }
}

class CalendarViewController extends GetxController {
  var currentView = CalendarView.day.obs;
  var events = <Event>[].obs;

  // Available colors for events
  static const List<Color> availableColors = [
    Color(0xFF0F8644), // Green
    Color(0xFFFF5722), // Red-Orange
    Color(0xFF2196F3), // Blue
    Color(0xFF9C27B0), // Purple
    Color(0xFFFF9800), // Orange
    Color(0xFF4CAF50), // Light Green
    Color(0xFFF44336), // Red
    Color(0xFFE91E63), // Pink
    Color(0xFF3F51B5), // Indigo
    Color(0xFF009688), // Teal
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  @override
  void onInit() {
    super.onInit();
    _loadInitialEvents();
  }

  void changeView(CalendarView view) {
    print('Changing view to: $view');
    currentView.value = view;
    print('Current view is now: ${currentView.value}');
  }

  void showEventOptions(dynamic appointment) {
    if (appointment is Event) {
      Get.dialog(
        AlertDialog(
          backgroundColor: KColors.darkModeSubCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            appointment.eventName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_formatDateTime(appointment.from)} - ${_formatDateTime(appointment.to)}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              _buildOptionTile(
                icon: IconsaxPlusLinear.eye,
                title: 'View Details',
                onTap: () {
                  Get.back();
                  showEventDetails(appointment);
                },
              ),
              _buildOptionTile(
                icon: IconsaxPlusLinear.edit,
                title: 'Edit Event',
                onTap: () {
                  Get.back();
                  showEditEventDialog(appointment);
                },
              ),
              _buildOptionTile(
                icon: IconsaxPlusLinear.trash,
                title: 'Delete Event',
                onTap: () {
                  Get.back();
                  _showDeleteConfirmation(appointment);
                },
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.white),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void showEditEventDialog(Event event) {
    Get.dialog(
      EditEventDialog(controller: this, event: event),
      barrierDismissible: true,
    );
  }

  void updateEvent(Event oldEvent, String title, DateTime startDate,
      DateTime endDate, bool isAllDay, Color selectedColor) {
    final int index = events.indexOf(oldEvent);
    if (index != -1) {
      events[index] = Event(
        title,
        startDate,
        endDate,
        selectedColor,
        isAllDay,
      );
      events.refresh();
      Get.back();
      KLoaders().successSnackBar(
        title: 'Success',
        message: 'Event updated successfully',
      );
    }
  }

  void showQuickAddEvent(DateTime selectedDate) {
    final TextEditingController quickTitleController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: KColors.darkModeSubCard,
        title: const Text(
          'Quick Add Event',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quickTitleController,
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Event title...',
                hintStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: KColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${_formatDate(selectedDate)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (quickTitleController.text.isNotEmpty) {
                final startTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  DateTime.now().hour,
                  0,
                );
                addEvent(
                  quickTitleController.text,
                  startTime,
                  startTime.add(const Duration(hours: 1)),
                  false,
                  availableColors[0], // Default color for quick add
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: KColors.primary),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Event event) {
    Get.dialog(
      AlertDialog(
        backgroundColor: KColors.darkModeSubCard,
        title: const Text(
          'Delete Event',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${event.eventName}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child:
                const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              removeEvent(event);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void addEvent(String title, DateTime startDate, DateTime endDate,
      bool isAllDay, Color selectedColor) {
    final newEvent = Event(
      title,
      startDate,
      endDate,
      selectedColor,
      isAllDay,
    );
    events.add(newEvent);
    Get.back();

    KLoaders().successSnackBar(
      title: 'Success',
      message: 'Event added successfully',
    );
  }

  void removeEvent(Event event) {
    events.remove(event);
  }

  void showEventDetails(dynamic appointment) {
    if (appointment is Event) {
      Get.dialog(
        AlertDialog(
          backgroundColor: KColors.darkModeSubCard,
          title: Text(
            appointment.eventName,
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Start: ${_formatDateTime(appointment.from)}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'End: ${_formatDateTime(appointment.to)}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'Duration: ${_formatDuration(appointment.to.difference(appointment.from))}',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                'All Day: ${appointment.isAllDay ? 'Yes' : 'No'}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    'Color: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: appointment.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  void _loadInitialEvents() {
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    events.add(Event(
      'Conference',
      startTime,
      endTime,
      availableColors[0],
      false,
    ));
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class Event {
  Event(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] as Event).from;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] as Event).to;
  }

  @override
  String getSubject(int index) {
    return (appointments![index] as Event).eventName;
  }

  @override
  Color getColor(int index) {
    return (appointments![index] as Event).background;
  }

  @override
  bool isAllDay(int index) {
    return (appointments![index] as Event).isAllDay;
  }
}

class AddEventDialog extends StatefulWidget {
  final CalendarViewController controller;

  const AddEventDialog({Key? key, required this.controller}) : super(key: key);

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController titleController = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now().add(const Duration(hours: 1));
  bool isAllDay = false;
  Color selectedColor = CalendarViewController.availableColors[0];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KColors.darkModeSubCard,
      title: const Text(
        'Add New Event',
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400, // Set a fixed height
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Date',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year} ${selectedStartDate.hour}:${selectedStartDate.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => _selectDateTime(context, true),
              ),
              ListTile(
                title: const Text('End Date',
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(
                  '${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year} ${selectedEndDate.hour}:${selectedEndDate.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => _selectDateTime(context, false),
              ),
              CheckboxListTile(
                title: const Text('All Day',
                    style: TextStyle(color: Colors.white)),
                value: isAllDay,
                onChanged: (value) => setState(() => isAllDay = value ?? false),
                activeColor: KColors.primary,
              ),
              const SizedBox(height: 16),
              // Color Selection
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose Color',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: CalendarViewController.availableColors
                          .map((color) => _buildColorOption(color))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              widget.controller.addEvent(
                titleController.text,
                selectedStartDate,
                selectedEndDate,
                isAllDay,
                selectedColor,
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: KColors.primary),
          child: const Text('Add Event'),
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white30,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStartDate ? selectedStartDate : selectedEndDate),
      );

      if (pickedTime != null) {
        final DateTime newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            selectedStartDate = newDateTime;
            if (selectedStartDate.isAfter(selectedEndDate)) {
              selectedEndDate = selectedStartDate.add(const Duration(hours: 1));
            }
          } else {
            selectedEndDate = newDateTime;
          }
        });
      }
    }
  }
}

class EditEventDialog extends StatefulWidget {
  final CalendarViewController controller;
  final Event event;

  const EditEventDialog(
      {Key? key, required this.controller, required this.event})
      : super(key: key);

  @override
  State<EditEventDialog> createState() => _EditEventDialogState();
}

class _EditEventDialogState extends State<EditEventDialog> {
  late TextEditingController titleController;
  late DateTime selectedStartDate;
  late DateTime selectedEndDate;
  late bool isAllDay;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.eventName);
    selectedStartDate = widget.event.from;
    selectedEndDate = widget.event.to;
    isAllDay = widget.event.isAllDay;
    selectedColor = widget.event.background;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: KColors.darkModeSubCard,
      title: const Text(
        'Edit Event',
        style: TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Event Title',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Date',
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(
                '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year} ${selectedStartDate.hour}:${selectedStartDate.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () => _selectDateTime(context, true),
            ),
            ListTile(
              title:
                  const Text('End Date', style: TextStyle(color: Colors.white)),
              subtitle: Text(
                '${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year} ${selectedEndDate.hour}:${selectedEndDate.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () => _selectDateTime(context, false),
            ),
            CheckboxListTile(
              title:
                  const Text('All Day', style: TextStyle(color: Colors.white)),
              value: isAllDay,
              onChanged: (value) => setState(() => isAllDay = value ?? false),
              activeColor: KColors.primary,
            ),
            const SizedBox(height: 16),
            // Color Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Choose Color',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: CalendarViewController.availableColors
                        .map((color) => _buildColorOption(color))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
        ),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              widget.controller.updateEvent(
                widget.event,
                titleController.text,
                selectedStartDate,
                selectedEndDate,
                isAllDay,
                selectedColor,
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: KColors.primary),
          child: const Text('Update'),
        ),
      ],
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white30,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? selectedStartDate : selectedEndDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStartDate ? selectedStartDate : selectedEndDate),
      );

      if (pickedTime != null) {
        final DateTime newDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStartDate) {
            selectedStartDate = newDateTime;
            if (selectedStartDate.isAfter(selectedEndDate)) {
              selectedEndDate = selectedStartDate.add(const Duration(hours: 1));
            }
          } else {
            selectedEndDate = newDateTime;
          }
        });
      }
    }
  }
}
