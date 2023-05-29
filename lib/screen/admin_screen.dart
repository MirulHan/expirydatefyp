import '../liblist/my_lib.dart';
import '../utils/sidebar.dart';
import '../utils/user_selection.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Admin Screen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: "App Users"),
            Tab(icon: Icon(Icons.receipt), text: "User Report"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          UsersTab(),
          UserSelection(),
        ],
      ),
    );
  }
}

class UsersTab extends StatelessWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['username']),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(document.id)
                      .delete();
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
