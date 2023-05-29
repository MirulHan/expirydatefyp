import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../liblist/my_lib.dart';
import '../utils/chat_message.dart';
import '../utils/sidebar.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _txtMessage = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late OpenAI openAI;
  final List<ChatMessage> _messages = []; // use the ChatMessage class
  String? systemMessage;

  final ScrollController _scrollController = ScrollController();

  void gptbot(String content) async {
    final request = ChatCompleteText(
      messages: [
        // Include system message if it's not null
        if (systemMessage != null)
          Map.of({"role": "system", "content": systemMessage!}),
        Map.of({"role": "user", "content": content})
      ],
      maxToken: 200,
      model: ChatModel.gptTurbo,
    );

    try {
      final response = await openAI.onChatCompletion(request: request);

      for (var element in response!.choices) {
        setState(() {
          _messages.add(ChatMessage(
              role: 'Bot', content: element.message?.content ?? ''));

          // Scroll to the bottom of the chat after bot's response
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        });
      }
    } catch (err) {
      if (err is OpenAIAuthError) {
        print('OpenAIAuthError error ${err.data?.error?.toMap()}');
      }
      if (err is OpenAIRateLimitError) {
        print('OpenAIRateLimitError error ${err.data?.error?.toMap()}');
      }
      if (err is OpenAIServerError) {
        print('OpenAIServerError error ${err.data?.error?.toMap()}');
      }
    }
  }

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        enableLog: true);
    loadData();
    super.initState();
  }

  void loadData() async {
    // Fetch the data from Firestore
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user currently signed in');
    }
    String uid = user.uid;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('products')
        .get();

    // Create DateFormat instance with your desired format
    DateFormat dateFormat = DateFormat('dd/MM/yy');

    // Parse the data into a format that the bot understands
    List<Map<String, dynamic>> products = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data['expDate'] != null) {
        // Convert the Timestamp to a DateTime, format it, then to a string
        data['expDate'] =
            dateFormat.format((data['expDate'] as Timestamp).toDate());
      }
      return data;
    }).toList();

    // Convert the product list to a JSON string so it can be sent as a text message
    String productsJson = jsonEncode(products);

    // Create an initial system message that provides the product information to the bot
    systemMessage = "This is the available product data: $productsJson";

    print(systemMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: const CustomAppBar(),
      body: Container(
        decoration: BoxDecoration(gradient: getFixedGradient()),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  bool isUser = _messages[index].role == 'User';
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? Colors.blue.shade200
                                  : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              _messages[index].content,
                              style: CustomColors.chattext,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              color: CustomColors.mintWhite,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _txtMessage,
                        decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: CustomColors.disctext),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (_txtMessage.text.isNotEmpty) {
                          setState(() {
                            _messages.add(ChatMessage(
                                role: 'User', content: _txtMessage.text));
                          });
                          gptbot(_txtMessage.text);
                          _txtMessage.clear();

                          // Scroll to the bottom of the chat
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
