import '../liblist/my_lib.dart';

class CustomCalendarAppBar extends CalendarAppBar {
  final ValueNotifier<DateTime?> selectedDateNotifier;
  CustomCalendarAppBar({
    Key? key,
    required List<DateTime> events,
    required double width,
    required this.selectedDateNotifier,
  }) : super(
          key: key,
          onDateChanged: (value) {
            selectedDateNotifier.value = value;
          },
          width: width,
          firstDate: DateTime.now().subtract(const Duration(days: 60)),
          lastDate: DateTime.now().add(const Duration(days: 150)),
          initialDate: DateTime.now(),
          weekOfYearLabel: "Week",
          white: CustomColors.mintWhite,
          black: CustomColors.black,
          accent: CustomColors.darkerMain,
          padding: 5.0,
          backButton: false,
          events: events,
        );
}
