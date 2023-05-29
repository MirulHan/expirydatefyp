import '../liblist/my_lib.dart';
import '../utils/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final String uid =
        FirebaseAuth.instance.currentUser!.uid; // get current user id

    return Scaffold(
      drawer: const SideBar(),
      appBar: const CustomAppBar(),
      backgroundColor: CustomColors.darkMain,
      body: Container(
        decoration: BoxDecoration(gradient: getFixedGradient()),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ExpirySegmentedView(uid: uid),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarApp(
        context: context,
        bottomNavigationBarIndex: 0,
      ),
    );
  }
}
