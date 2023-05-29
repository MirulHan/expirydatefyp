import '../liblist/my_lib.dart';
import '../utils/product_display.dart';
import '../utils/sidebar.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  NewScreenState createState() => NewScreenState();
}

class NewScreenState extends State<NewScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime? selectedDate;
  ValueNotifier<DateTime?> selectedDateNotifier =
      ValueNotifier<DateTime?>(null);
  final FirebaseService firebaseService = FirebaseService();
  late Future<List<DateTime>> events;

  @override
  void initState() {
    events = firebaseService.getProductExpiryDates();
    events.then((List<DateTime> dates) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Events loaded successfully!'),
        ),
      );
    });
    setState(() {
      selectedDate = DateTime.now();
    });
    super.initState();
  }

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("No user is currently signed in."));
    }

    return FutureBuilder<List<DateTime>>(
      future: events,
      builder: (BuildContext context, AsyncSnapshot<List<DateTime>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          return Container(
            decoration: BoxDecoration(
              gradient: getFixedGradient(),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              drawer: const SideBar(),
              appBar: CustomCalendarAppBar(
                events: snapshot.data ?? [],
                width: MediaQuery.of(context).size.width,
                selectedDateNotifier: selectedDateNotifier,
              ),
              body: FirestoreListView(
                uid: currentUser.uid,
                selectedDateNotifier: selectedDateNotifier,
              ),
              bottomNavigationBar: BottomNavigationBarApp(
                context: context,
                bottomNavigationBarIndex: 2,
              ),
            ),
          );
        }
      },
    );
  }
}
