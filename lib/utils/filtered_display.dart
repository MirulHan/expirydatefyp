import '../liblist/my_lib.dart';
import '../utils/filter_listview.dart';

class ExpirySegmentedView extends StatefulWidget {
  final String uid;

  const ExpirySegmentedView({Key? key, required this.uid}) : super(key: key);

  @override
  ExpirySegmentedViewState createState() => ExpirySegmentedViewState();
}

class ExpirySegmentedViewState extends State<ExpirySegmentedView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 10,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(child: Text('Today', style: CustomColors.mainstext)),
            Tab(child: Text('Tmrw', style: CustomColors.mainstext)),
            Tab(child: Text('Week', style: CustomColors.mainstext)),
            Tab(child: Text('Month', style: CustomColors.mainstext)),
          ],
        ),
      ),
      backgroundColor: CustomColors.light4Main,
      body: TabBarView(
        controller: _tabController,
        children: [
          FirestoreFilteredListView(uid: widget.uid, filter: _todayFilter),
          FirestoreFilteredListView(uid: widget.uid, filter: _tomorrowFilter),
          FirestoreFilteredListView(uid: widget.uid, filter: _thisWeekFilter),
          FirestoreFilteredListView(uid: widget.uid, filter: _thisMonthFilter),
        ],
      ),
    );
  }

  bool _todayFilter(DocumentSnapshot product) {
    DateTime expDate = product['expDate'].toDate();
    DateTime now = DateTime.now();
    return _isSameDay(expDate, now);
  }

  bool _tomorrowFilter(DocumentSnapshot product) {
    DateTime expDate = product['expDate'].toDate();
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    return _isSameDay(expDate, tomorrow);
  }

  bool _thisWeekFilter(DocumentSnapshot product) {
    DateTime expDate = product['expDate'].toDate();
    DateTime now = DateTime.now();
    return expDate.isAfter(now) &&
        expDate.isBefore(now.add(const Duration(days: 7)));
  }

  bool _thisMonthFilter(DocumentSnapshot product) {
    DateTime expDate = product['expDate'].toDate();
    DateTime now = DateTime.now();
    return expDate.isAfter(now) &&
        expDate.isBefore(DateTime(now.year, now.month + 1, now.day));
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
