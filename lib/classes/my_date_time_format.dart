import 'package:mooweapp/export_files.dart';
class MyDateTimeFormat {
  Timestamp timestamp;

  final now = DateTime.now();

  MyDateTimeFormat(this.timestamp);
  Widget dateFormat() {
    final fifteenAgo = DateTime.now().subtract(Duration(minutes: timestamp.toDate().minute));

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    TextStyle style = themeData!.textTheme.bodyText1!.copyWith(color: Colors.white, fontSize: 10);
    final aDate = DateTime(timestamp.toDate().year, timestamp.toDate().month, timestamp.toDate().day);
    if (aDate == today) {
      if (aDate.isBefore(today.add(const Duration(minutes: 60)))) {
        return MarqueeWidget(
            child: Text("last seen ${format(timestamp.toDate())}",
              style: style,
            ),
        );
      }
      return MarqueeWidget(
        child: Text(
          DateFormat.jm().format(timestamp.toDate()),
          style: style,
        ),
      );
    } else if (aDate == yesterday) {
      return MarqueeWidget(
          child: Text(
        "last seen ${format(timestamp.toDate())}",
        style: style,
      ));
    } else if (aDate.isBefore(findLastDateOfTheWeek(aDate))) {
      return Text(
        "last seen ${format(timestamp.toDate())}",
        style: style,
      );
      // return Text(DateFormat.EEEE().format(timestamp!.toDate()));
    } else {
      return MarqueeWidget(
        child: Text(dateFormatter(timestamp.toDate())),
      );
    }
  }

  chatDateFormat() {
    final fifteenAgo = DateTime.now().subtract(Duration(minutes: timestamp.toDate().minute));

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    // final aDate = DateTime(timestamp!.toDate().year, timestamp!.toDate().month, timestamp!.toDate().day);
    // if (aDate == today) {
    //   return DateFormat.jm().format(timestamp!.toDate());
    // } else if (aDate == yesterday) {
    //   return "Yesterday";
    // } else if (aDate.isBefore(findLastDateOfTheWeek(aDate))) {
    //   return DateFormat.EEEE().format(timestamp!.toDate());
    // } else {
    //   return DateFormat.yMd().format(timestamp!.toDate());
    // }

    // return DateFormat.jms().format(timestamp.toDate()) == 9:30 AM;
    // return DateFormat.MEd().format(timestamp.toDate()) == Sat, 11/25;
    // return DateFormat.M().format(timestamp.toDate()) == 11;
    // return DateFormat.Md().format(timestamp.toDate()) == 11/23;
    // return DateFormat.MMM().format(yesterday) == Nov;
    // return DateFormat.MMMd().format(yesterday) == Nov 26;
    // return DateFormat.MMMMEEEEd().format(yesterday) Friday Novembe 26;
    // return DateFormat.EEEE().format(yesterday) == Friday;
    // return DateFormat.E().format(yesterday) == Fri;
    // return DateFormat.MMMMd().format(yesterday) == Novenber 26;
    // return DateFormat.jm().format(timestamp.toDate()) 9:13 PM;
    if(timestamp.toDate().day == today.day) return DateFormat.jm().format(timestamp.toDate());
    if(timestamp.toDate().day == today.day -1) return "Yesterday ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day == today.day - 2) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day == today.day - 3) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day == today.day - 4) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day == today.day - 5) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day == today.day - 6) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    if(timestamp.toDate().day == today.day - 7) return "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
    return  "${DateFormat.E().format(timestamp.toDate())} ${DateFormat.jm().format(timestamp.toDate())}";
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  String dateFormatter(DateTime date) {
    dynamic dayData = '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

    dynamic monthData = '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';

    return json.decode(dayData)['${date.weekday}'] + ", " + date.day.toString() + " " + json.decode(monthData)['${date.month}'] + " " + date.year.toString();
  }
}

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  const MarqueeWidget({
    Key? key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 6000),
    this.backDuration = const Duration(milliseconds: 800),
    this.pauseDuration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 100.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.ease,
        );
      }
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients) {
        await scrollController.animateTo(
          0.0,
          duration: widget.backDuration,
          curve: Curves.easeOut,
        );
      }
    }
  }
}
