import '../liblist/my_lib.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../utils/notification_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationWidget.init();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expiry Date Alert Application',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const SignInScreen(),
    );
  }
}
