import '../liblist/my_lib.dart';

class BottomNavigationBarApp extends StatelessWidget {
  final int bottomNavigationBarIndex;
  final BuildContext context;

  const BottomNavigationBarApp({
    Key? key,
    required this.context,
    required this.bottomNavigationBarIndex,
  }) : super(key: key);

  void onTabTapped(int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        if (index == 0) {
          return const HomeScreen();
        } else if (index == 1) {
          return const InputItem();
        } else {
          return const NewScreen();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: CustomColors.mintWhite,
      currentIndex: bottomNavigationBarIndex,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 15,
      selectedLabelStyle: const TextStyle(color: CustomColors.darkerMain),
      selectedItemColor: CustomColors.darkerMain,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: SizedBox(
              width: 20, // specify your desired width
              height: 20, // specify your desired height
              child: Image.asset(
                'assets/images/home.png',
                color: (bottomNavigationBarIndex == 0)
                    ? CustomColors.darkerMain
                    : CustomColors.textGrey,
              ),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: SizedBox(
              width: 20, // specify your desired width
              height: 20, // specify your desired height
              child: Image.asset(
                'assets/images/task.png',
                color: (bottomNavigationBarIndex == 1)
                    ? CustomColors.darkerMain
                    : CustomColors.textGrey,
              ),
            ),
          ),
          label: 'Scanner',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: SizedBox(
              width: 20,
              height: 20,
              child: Image.asset(
                'assets/images/calendar.png',
                color: (bottomNavigationBarIndex == 2)
                    ? CustomColors.darkerMain
                    : CustomColors.textGrey,
              ),
            ),
          ),
          label: 'Calendar',
        ),
      ],
      onTap: onTabTapped,
    );
  }
}
