import '../liblist/my_lib.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  String selectedRole = 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: getFixedGradient(),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_2_outlined,
                    false, _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                  value: selectedRole,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  items: <String>['Admin', 'User']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((UserCredential userCredential) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user?.uid)
                        .set({
                      'email': _emailTextController.text,
                      'username': _userNameTextController.text,
                      'role': selectedRole,
                    }).then((value) {
                      const snackBar = SnackBar(
                        content: Text('Account created successfully'),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    }).catchError((error) {
                      final snackBar = SnackBar(
                        content:
                            Text('Error: ${error.message ?? "Unknown error"}'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
