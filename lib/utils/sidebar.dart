import 'package:expirydatefyp/liblist/my_lib.dart';

import '../screen/admin_screen.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isAdmin = false;
  String username = '', email = '';
  @override
  void initState() {
    super.initState();
    _checkIfUserIsAdmin();
  }

  void _checkIfUserIsAdmin() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          username = doc[
              'username']; // assuming you have a username field in the user document
          email = user.email ?? ''; // get the email from the User object
          isAdmin = doc['role'] == 'Admin';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              username,
              style: CustomColors.usertext,
            ), // display username
            accountEmail: Text(
              email,
              style: CustomColors.emailtext,
            ), // display email
            currentAccountPicture: const CircleAvatar(
              child: ClipOval(
                child: Image(
                  image: AssetImage('assets/images/BellIcon.png'),
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: CustomColors.darkMain,
              image: DecorationImage(
                  image: AssetImage('assets/images/yellow.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('Home', style: CustomColors.maintext),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: Text('Add Item', style: CustomColors.maintext),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InputItem()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text('Calendar', style: CustomColors.maintext),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: Text('Chat Screen', style: CustomColors.maintext),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()),
              );
            },
          ),
          if (isAdmin)
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text('Admin Screen', style: CustomColors.maintext),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminScreen()),
                );
              },
            ),
          const SizedBox(height: 200),
          const Divider(
            height: 10,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('Logout', style: CustomColors.maintext),
            onTap: () {
              FirebaseAuth.instance.signOut().then((value) {
                const snackBar = SnackBar(
                  content: Text('Logged out successfully'),
                  backgroundColor: Colors.green,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
